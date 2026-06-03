import { prisma } from '../../config/database';
import { generateImageWithPollinations } from '../providers/pollinations.provider';
import { generateCaption } from '../providers/caption.provider';
import { generateVideo } from '../providers/video.provider';
import { analyzeProductImage } from '../providers/gemini.analyzer';
import { getPlatformPrompts, Platform, BackgroundStyle } from './platform.prompts';
import { GenerationStatus } from '@prisma/client';
import { getSignedUrlForPath, uploadToSupabaseStorage } from '../providers/storage.helper';
import { removeProductBackground } from '../providers/background-removal.helper';
import { compositeProductOnBackground } from '../providers/composite.helper';
import { normalizeToJpeg, downscaleToMaxEdge } from '../providers/image-normalize.helper';
import { generateLocalBackdrop } from '../providers/local-backdrop.helper';
import { generatePixazoBackdrop, isPixazoConfigured } from '../providers/pixazo.provider';



// Ayni anda yalnizca BIR pipeline calissin: es zamanli iki agir is (ONNX modeli +
// buyuk gorsel + ffmpeg) dusuk bellekli sunucuda OOM yapiyordu. Basit in-process kuyruk.
let pipelineChain: Promise<void> = Promise.resolve();

export function runGenerationPipeline(generationId: string): Promise<void> {
  const next = pipelineChain.then(() => runPipelineInternal(generationId));
  pipelineChain = next.catch(() => {}); // zincir kopmasin
  return next;
}

async function runPipelineInternal(generationId: string): Promise<void> {
  const startTime = Date.now();
  console.log(`🚀 Starting advanced generation pipeline for ID: ${generationId}`);

  try {
    // 1. Fetch Generation details
    const generation = await prisma.generation.findUnique({
      where: { id: generationId },
      include: {
        user: {
          include: {
            brandKit: true,
          },
        },
      },
    });

    if (!generation) {
      throw new Error(`Generation with ID ${generationId} not found`);
    }

    // 2. Fetch AI configurations from database
    const configs = await prisma.aiConfig.findMany();
    const imageConfig = configs.find((c) => c.taskType === 'image');
    const analysisConfig = configs.find((c) => c.taskType === 'analysis');
    const captionConfig = configs.find((c) => c.taskType === 'caption');
    const videoConfig = configs.find((c) => c.taskType === 'video');

    // 3. Step 0: Perform Visual Product Image Analysis using Gemini Flash
    console.log(`🔍 Step 0/3: Visual Product Image Analysis for ID: ${generationId}`);
    let originalUrl = generation.originalImagePath;
    if (!originalUrl.startsWith('http')) {
      const signed = await getSignedUrlForPath('uploads', originalUrl);
      if (signed) {
        originalUrl = signed;
      }
    }

    const analysis = await analyzeProductImage(
      originalUrl,
      analysisConfig?.apiKey,
      analysisConfig?.activeModel
    );

    // 4. Resolve platform-specific dynamic prompts
    const platform = (generation.platform || 'instagram') as Platform;
    const options = (generation.options as any) || {};
    const backgroundStyle = normalizeBackgroundStyle(options.imageStyle);
    // Marka adi YALNIZCA acikca verildiyse kullanilir. Kullanicinin kisisel displayName'i
    // (orn. "Erkan Turgut") marka degildir; caption'larda kisi adi kullanmamak icin
    // displayName'i ENJEKTE ETME. Ileride BrandKit/marka alani options.brandName ile gelebilir.
    const brandName = (typeof options.brandName === 'string' && options.brandName.trim())
      ? options.brandName.trim()
      : undefined;
    const extraContext = options.extraContext || undefined;
    const templateId = options.templateId || undefined;

    const basePrompts = getPlatformPrompts(
      platform,
      backgroundStyle,
      analysis,
      brandName,
      extraContext
    );

    let finalBackgroundPrompt = basePrompts.backgroundPrompt;
    let emptyBackdropPrompt = basePrompts.emptyBackdropPrompt || basePrompts.backgroundPrompt;
    let finalVideoPrompt = basePrompts.videoPrompt;
    let finalCaptionSystem = basePrompts.captionSystemPrompt;
    let finalCaptionUser = basePrompts.captionUserPrompt;

    // 5. Apply Admin Template Override if templateId is specified
    if (templateId) {
      const template = await prisma.adminTemplate.findUnique({
        where: { id: templateId },
      });
      if (template) {
        console.log(`✨ Applying Admin Template Override: ${template.name}`);
        if (template.backgroundSystemPrompt) {
          finalBackgroundPrompt = `${template.backgroundSystemPrompt}\n\nÜrün: ${analysis.productType}. Renkler: ${analysis.dominantColors.join(', ')}.`;
          emptyBackdropPrompt = `${template.backgroundSystemPrompt}

Important: Generate an empty photorealistic product photography scene with one clear, level, uninterrupted landing surface across the lower third. Keep the horizontal center empty. Use a front-facing realistic camera angle and natural light. No products, bottles, packages, hands, props, text, or watermarks.`;
        }
        if (template.videoSystemPrompt) {
          finalVideoPrompt = template.videoSystemPrompt;
        }
        if (template.captionSystemPrompt) {
          finalCaptionSystem = template.captionSystemPrompt;
        }
        if (template.captionUserPromptSuffix) {
          finalCaptionUser = `${basePrompts.captionUserPrompt}\n\nEk Şablon Notu: ${template.captionUserPromptSuffix}`;
        }
      }
    }

    // 6. Step 1: Image Generation
    console.log(`🎨 Step 1/3: Image generation for ID: ${generationId}`);
    await prisma.generation.update({
      where: { id: generationId },
      data: {
        status: GenerationStatus.processing_image,
        imageModel: imageConfig?.activeModel || 'pollinations',
      },
    });

    // Orijinali indir + normalize et (HEIC/HEIF → JPEG). iPhone fotograflari HEIC gelir;
    // @imgly arka plan kaldirma ve ffmpeg HEIC okuyamaz. Normalize ederek tum downstream
    // adimlarin (kesim, kompozit, ffmpeg, Flutter render) calismasini garanti ederiz.
    console.log(`🔄 [Cutout Flow] Downloading original product image from: ${originalUrl}`);
    const originalRes = await fetch(originalUrl);
    if (!originalRes.ok) {
      throw new Error(`Failed to download original product image: ${originalRes.statusText}`);
    }
    const rawBuffer = Buffer.from(await originalRes.arrayBuffer());
    const { buffer: jpegBuffer } = await normalizeToJpeg(
      rawBuffer,
      originalRes.headers.get('content-type'),
      originalUrl
    );
    // Isleme oncesi kucult (OOM'u onler; final urun zaten kucuk kullanilir).
    const normalizedBuffer = await downscaleToMaxEdge(jpegBuffer, 1440);

    let processedImageUrl = '';
    try {
      console.log('✂️ [Cutout Flow] Extracting transparent product PNG...');
      const productPngBuffer = await removeProductBackground(normalizedBuffer, 'image/jpeg');

      // Arka plan zinciri: 1) Pixazo (SDXL, varsa) → 2) Pollinations (flux) →
      // 3) %100 yerel/ucretsiz studyo arka plani. Her durumda urun temiz bir
      // sahneye kompozit edilir (duz orijinale ASLA dusmez).
      const textFreeBackdropPrompt =
        `${emptyBackdropPrompt}\n\nStyle: premium product photography, soft diffused studio lighting, ` +
        `shallow depth of field, gentle gradient, high detail, clean and professional, 8k.\n\n` +
        `CRITICAL: The image must contain ABSOLUTELY NO text, letters, words, numbers, ` +
        `typography, captions, labels, logos, signs, watermarks or writing of any kind. A clean, empty, ` +
        `photorealistic background scene only.`;

      let backdropBuffer: Buffer | null = null;

      // 1) Pixazo (yapilandirilmissa)
      if (isPixazoConfigured()) {
        try {
          console.log('🌅 [Cutout Flow] Generating backdrop from Pixazo (SDXL)...');
          backdropBuffer = await generatePixazoBackdrop(textFreeBackdropPrompt);
        } catch (pixazoError: any) {
          console.warn(`⚠️ [Cutout Flow] Pixazo backdrop failed (${pixazoError.message}); Pollinations denenecek.`);
        }
      }

      // 2) Pollinations
      if (!backdropBuffer) {
        try {
          console.log('🌅 [Cutout Flow] Generating clean empty scene backdrop from Pollinations...');
          const backdropUrl = await generateImageWithPollinations(textFreeBackdropPrompt, generationId, imageConfig);
          console.log(`📥 [Cutout Flow] Downloading generated scene backdrop from: ${backdropUrl}`);
          const backdropRes = await fetch(backdropUrl);
          if (!backdropRes.ok) {
            throw new Error(`Failed to download backdrop image: ${backdropRes.statusText}`);
          }
          backdropBuffer = Buffer.from(await backdropRes.arrayBuffer());
        } catch (backdropError: any) {
          console.warn(`⚠️ [Cutout Flow] Pollinations backdrop failed (${backdropError.message}); yerel studyo arka plani kullaniliyor.`);
        }
      }

      // 3) Yerel studyo arka plani (her zaman calisir)
      if (!backdropBuffer) {
        backdropBuffer = await generateLocalBackdrop(1080, 1080, backgroundStyle);
      }

      console.log('🎨 [Cutout Flow] Compositing product cutout onto backdrop...');
      const compositedBuffer = await compositeProductOnBackground(productPngBuffer, backdropBuffer);

      console.log('📤 [Cutout Flow] Uploading composited result to Supabase Storage...');
      const compositedUrl = await uploadToSupabaseStorage(
        compositedBuffer,
        `images/${generationId}.jpg`,
        'results',
        'image/jpeg'
      );

      if (!compositedUrl) {
        throw new Error('Composited image upload returned null URL');
      }

      processedImageUrl = compositedUrl;
      console.log(`✅ [Cutout Flow] Successfully created composited product image! URL: ${processedImageUrl}`);
    } catch (cutoutError: any) {
      console.warn(`⚠️ [Cutout Flow] Background processing failed. Falling back to normalized original:`, cutoutError.message);
      // Normalize edilmis JPEG'i yukle — hem Flutter render eder hem ffmpeg isleyebilir
      // (orijinal HEIC yerine). Boylece video fallback'i de calisabilir.
      const fallbackUrl = await uploadToSupabaseStorage(
        normalizedBuffer,
        `images/${generationId}.jpg`,
        'results',
        'image/jpeg'
      );
      processedImageUrl = fallbackUrl || originalUrl;
    }


    // 7. Step 2 & 3: Run Caption and Video Generation in Parallel using Promise.allSettled
    console.log(`✍️🎬 Step 2 & 3: Parallel Caption and Video generation for ID: ${generationId}`);
    await prisma.generation.update({
      where: { id: generationId },
      data: {
        status: GenerationStatus.generating_caption,
        processedImagePath: processedImageUrl,
        captionModel: captionConfig?.activeModel || 'gemini-flash',
        videoModel: videoConfig?.activeModel || 'ken-burns-local',
      },
    });

    const fullCaptionPrompt = `System instructions:\n${finalCaptionSystem}\n\nUser context:\n${finalCaptionUser}`;

    const [captionResult, videoResult] = await Promise.allSettled([
      generateCaption(fullCaptionPrompt, captionConfig),
      generateVideo({
        imageUrl: processedImageUrl,
        sector: generation.sector,
        generationId,
        prompt: finalVideoPrompt,
        config: videoConfig,
      }),
    ]);

    let finalCaption = 'Ürün açıklaması üretilemedi.';
    let finalHashtags: string[] = [];
    let finalVideoUrl = '';

    if (captionResult.status === 'fulfilled') {
      finalCaption = captionResult.value.caption;
      finalHashtags = captionResult.value.hashtags;
    } else {
      console.error(`⚠️ Caption generation failed for ID ${generationId}:`, captionResult.reason);
    }

    if (videoResult.status === 'fulfilled') {
      finalVideoUrl = videoResult.value || '';
    } else {
      console.error(`⚠️ Video generation failed for ID ${generationId}:`, videoResult.reason);
    }

    const durationMs = Date.now() - startTime;

    // 8. Complete the Generation
    console.log(`✅ Pipeline completed for ID: ${generationId} in ${durationMs}ms`);
    await prisma.generation.update({
      where: { id: generationId },
      data: {
        status: GenerationStatus.completed,
        caption: finalCaption,
        hashtags: finalHashtags,
        videoPath: finalVideoUrl || null,
        processingMs: durationMs,
        completedAt: new Date(),
      },
    });
  } catch (error: any) {
    console.error(`❌ Pipeline failed for ID: ${generationId}:`, error.message);
    const durationMs = Date.now() - startTime;
    await prisma.generation.update({
      where: { id: generationId },
      data: {
        status: GenerationStatus.failed,
        errorMessage: error.message,
        processingMs: durationMs,
        completedAt: new Date(),
      },
    });
  }
}

function normalizeBackgroundStyle(value: unknown): BackgroundStyle {
  // Flutter'in gonderdigi tum tema id'lerini gecerli bir BackgroundStyle'a haritala.
  // Eslesmeyen/bilinmeyen deger 'studio_white'a duser; boylece prompt'a asla
  // 'undefined' girmez (luxury/neon/gradient daha once undefined uretiyordu).
  const aliases: Record<string, BackgroundStyle> = {
    studio: 'studio_white',
    studio_white: 'studio_white',
    studio_dark: 'studio_dark',
    dark: 'studio_dark',
    luxury: 'studio_dark',
    outdoor: 'nature_outdoor',
    nature: 'nature_outdoor',
    nature_outdoor: 'nature_outdoor',
    home: 'lifestyle',
    lifestyle: 'lifestyle',
    minimalist: 'minimalist',
    neon: 'ai_generated',
    gradient: 'ai_generated',
    ai_generated: 'ai_generated',
  };
  const key = String(value || 'studio_white').toLowerCase();
  return aliases[key] || 'studio_white';
}
