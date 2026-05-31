"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.runGenerationPipeline = runGenerationPipeline;
const database_1 = require("../../config/database");
const pollinations_provider_1 = require("../providers/pollinations.provider");
const caption_provider_1 = require("../providers/caption.provider");
const video_provider_1 = require("../providers/video.provider");
const gemini_analyzer_1 = require("../providers/gemini.analyzer");
const platform_prompts_1 = require("./platform.prompts");
const client_1 = require("@prisma/client");
const storage_helper_1 = require("../providers/storage.helper");
const background_removal_helper_1 = require("../providers/background-removal.helper");
const composite_helper_1 = require("../providers/composite.helper");
async function runGenerationPipeline(generationId) {
    const startTime = Date.now();
    console.log(`🚀 Starting advanced generation pipeline for ID: ${generationId}`);
    try {
        // 1. Fetch Generation details
        const generation = await database_1.prisma.generation.findUnique({
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
        const configs = await database_1.prisma.aiConfig.findMany();
        const imageConfig = configs.find((c) => c.taskType === 'image');
        const analysisConfig = configs.find((c) => c.taskType === 'analysis');
        const captionConfig = configs.find((c) => c.taskType === 'caption');
        const videoConfig = configs.find((c) => c.taskType === 'video');
        // 3. Step 0: Perform Visual Product Image Analysis using Gemini Flash
        console.log(`🔍 Step 0/3: Visual Product Image Analysis for ID: ${generationId}`);
        let originalUrl = generation.originalImagePath;
        if (!originalUrl.startsWith('http')) {
            const signed = await (0, storage_helper_1.getSignedUrlForPath)('uploads', originalUrl);
            if (signed) {
                originalUrl = signed;
            }
        }
        const analysis = await (0, gemini_analyzer_1.analyzeProductImage)(originalUrl, analysisConfig?.apiKey, analysisConfig?.activeModel);
        // 4. Resolve platform-specific dynamic prompts
        const platform = (generation.platform || 'instagram');
        const options = generation.options || {};
        const backgroundStyle = normalizeBackgroundStyle(options.imageStyle);
        const brandName = generation.user.displayName || undefined;
        const extraContext = options.extraContext || undefined;
        const templateId = options.templateId || undefined;
        const basePrompts = (0, platform_prompts_1.getPlatformPrompts)(platform, backgroundStyle, analysis, brandName, extraContext);
        let finalBackgroundPrompt = basePrompts.backgroundPrompt;
        let emptyBackdropPrompt = basePrompts.emptyBackdropPrompt || basePrompts.backgroundPrompt;
        let finalVideoPrompt = basePrompts.videoPrompt;
        let finalCaptionSystem = basePrompts.captionSystemPrompt;
        let finalCaptionUser = basePrompts.captionUserPrompt;
        // 5. Apply Admin Template Override if templateId is specified
        if (templateId) {
            const template = await database_1.prisma.adminTemplate.findUnique({
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
        await database_1.prisma.generation.update({
            where: { id: generationId },
            data: {
                status: client_1.GenerationStatus.processing_image,
                imageModel: imageConfig?.activeModel || 'pollinations',
            },
        });
        let processedImageUrl = '';
        try {
            console.log(`🔄 [Cutout Flow] Downloading original product image from: ${originalUrl}`);
            const originalRes = await fetch(originalUrl);
            if (!originalRes.ok) {
                throw new Error(`Failed to download original product image: ${originalRes.statusText}`);
            }
            const originalBuffer = Buffer.from(await originalRes.arrayBuffer());
            console.log('✂️ [Cutout Flow] Extracting transparent product PNG...');
            const productPngBuffer = await (0, background_removal_helper_1.removeProductBackground)(originalBuffer, originalRes.headers.get('content-type'));
            console.log('🌅 [Cutout Flow] Generating clean empty scene backdrop from Pollinations...');
            const backdropUrl = await (0, pollinations_provider_1.generateImageWithPollinations)(emptyBackdropPrompt, generationId, imageConfig);
            console.log(`📥 [Cutout Flow] Downloading generated scene backdrop from: ${backdropUrl}`);
            const backdropRes = await fetch(backdropUrl);
            if (!backdropRes.ok) {
                throw new Error(`Failed to download backdrop image: ${backdropRes.statusText}`);
            }
            const backdropBuffer = Buffer.from(await backdropRes.arrayBuffer());
            console.log('🎨 [Cutout Flow] Compositing product cutout onto backdrop...');
            const compositedBuffer = await (0, composite_helper_1.compositeProductOnBackground)(productPngBuffer, backdropBuffer);
            console.log('📤 [Cutout Flow] Uploading composited result to Supabase Storage...');
            const compositedUrl = await (0, storage_helper_1.uploadToSupabaseStorage)(compositedBuffer, `images/${generationId}.jpg`, 'results', 'image/jpeg');
            if (!compositedUrl) {
                throw new Error('Composited image upload returned null URL');
            }
            processedImageUrl = compositedUrl;
            console.log(`✅ [Cutout Flow] Successfully created composited product image! URL: ${processedImageUrl}`);
        }
        catch (cutoutError) {
            console.warn(`⚠️ [Cutout Flow] Background processing failed. Preserving original product image:`, cutoutError.message);
            processedImageUrl = originalUrl;
        }
        // 7. Step 2 & 3: Run Caption and Video Generation in Parallel using Promise.allSettled
        console.log(`✍️🎬 Step 2 & 3: Parallel Caption and Video generation for ID: ${generationId}`);
        await database_1.prisma.generation.update({
            where: { id: generationId },
            data: {
                status: client_1.GenerationStatus.generating_caption,
                processedImagePath: processedImageUrl,
                captionModel: captionConfig?.activeModel || 'gemini-flash',
                videoModel: videoConfig?.activeModel || 'fal-kaiber',
            },
        });
        const fullCaptionPrompt = `System instructions:\n${finalCaptionSystem}\n\nUser context:\n${finalCaptionUser}`;
        const [captionResult, videoResult] = await Promise.allSettled([
            (0, caption_provider_1.generateCaption)(fullCaptionPrompt, captionConfig),
            (0, video_provider_1.generateVideo)({
                imageUrl: processedImageUrl,
                sector: generation.sector,
                generationId,
                prompt: finalVideoPrompt,
                config: videoConfig,
            }),
        ]);
        let finalCaption = 'Ürün açıklaması üretilemedi.';
        let finalHashtags = [];
        let finalVideoUrl = '';
        if (captionResult.status === 'fulfilled') {
            finalCaption = captionResult.value.caption;
            finalHashtags = captionResult.value.hashtags;
        }
        else {
            console.error(`⚠️ Caption generation failed for ID ${generationId}:`, captionResult.reason);
        }
        if (videoResult.status === 'fulfilled') {
            finalVideoUrl = videoResult.value || '';
        }
        else {
            console.error(`⚠️ Video generation failed for ID ${generationId}:`, videoResult.reason);
        }
        const durationMs = Date.now() - startTime;
        // 8. Complete the Generation
        console.log(`✅ Pipeline completed for ID: ${generationId} in ${durationMs}ms`);
        await database_1.prisma.generation.update({
            where: { id: generationId },
            data: {
                status: client_1.GenerationStatus.completed,
                caption: finalCaption,
                hashtags: finalHashtags,
                videoPath: finalVideoUrl || null,
                processingMs: durationMs,
                completedAt: new Date(),
            },
        });
    }
    catch (error) {
        console.error(`❌ Pipeline failed for ID: ${generationId}:`, error.message);
        const durationMs = Date.now() - startTime;
        await database_1.prisma.generation.update({
            where: { id: generationId },
            data: {
                status: client_1.GenerationStatus.failed,
                errorMessage: error.message,
                processingMs: durationMs,
                completedAt: new Date(),
            },
        });
    }
}
function normalizeBackgroundStyle(value) {
    const aliases = {
        studio: 'studio_white',
        outdoor: 'nature_outdoor',
        nature: 'nature_outdoor',
        home: 'lifestyle',
    };
    const normalized = String(value || 'studio_white');
    return aliases[normalized] || normalized;
}
