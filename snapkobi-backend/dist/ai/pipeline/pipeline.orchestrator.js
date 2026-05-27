"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.runGenerationPipeline = runGenerationPipeline;
const database_1 = require("../../config/database");
const pollinations_provider_1 = require("../providers/pollinations.provider");
const gemini_provider_1 = require("../providers/gemini.provider");
const video_provider_1 = require("../providers/video.provider");
const gemini_analyzer_1 = require("../providers/gemini.analyzer");
const platform_prompts_1 = require("./platform.prompts");
const client_1 = require("@prisma/client");
const storage_helper_1 = require("../providers/storage.helper");
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
        const analysis = await (0, gemini_analyzer_1.analyzeProductImage)(originalUrl, captionConfig?.apiKey);
        // 4. Resolve platform-specific dynamic prompts
        const platform = (generation.platform || 'instagram');
        const options = generation.options || {};
        const backgroundStyle = (options.imageStyle || 'studio_white');
        const brandName = generation.user.displayName || undefined;
        const extraContext = options.extraContext || undefined;
        const templateId = options.templateId || undefined;
        const basePrompts = (0, platform_prompts_1.getPlatformPrompts)(platform, backgroundStyle, analysis, brandName, extraContext);
        let finalBackgroundPrompt = basePrompts.backgroundPrompt;
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
        const processedImageUrl = await (0, pollinations_provider_1.generateImageWithPollinations)(finalBackgroundPrompt, generationId);
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
            (0, gemini_provider_1.generateCaptionWithGemini)(fullCaptionPrompt, captionConfig?.apiKey),
            (0, video_provider_1.generateVideo)(processedImageUrl, generation.sector, videoConfig?.apiKey, finalVideoPrompt),
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
            finalVideoUrl = videoResult.value;
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
