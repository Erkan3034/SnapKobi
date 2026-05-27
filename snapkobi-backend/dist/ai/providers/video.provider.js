"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateVideo = generateVideo;
const client_1 = require("@prisma/client");
const env_1 = require("../../config/env");
async function generateVideo(imageUrl, sector, customApiKey, customPrompt) {
    const apiKey = customApiKey || env_1.env.FAL_KEY;
    if (!apiKey) {
        console.warn('⚠️ No FAL_KEY found in environment. Falling back to stock simulated video.');
        return getStockVideo(sector);
    }
    try {
        const finalPrompt = customPrompt || 'An elegant cinematic showcase of the product, smooth slow motion, soft professional lighting, premium dynamic advertisement style';
        console.log(`🎬 Calling Fal.ai to generate real video from image: ${imageUrl} with prompt: ${finalPrompt}`);
        const response = await fetch('https://queue.fal.run/fal-ai/luma-dream-machine/image-to-video', {
            method: 'POST',
            headers: {
                'Authorization': `Key ${apiKey}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image_url: imageUrl,
                prompt: finalPrompt,
            }),
        });
        if (!response.ok) {
            throw new Error(`Fal.ai API responded with status: ${response.status}`);
        }
        const queueData = await response.json();
        const requestId = queueData.request_id;
        if (!requestId) {
            throw new Error('Fal.ai returned empty request ID');
        }
        console.log(`🎬 Polling Fal.ai request status: ${requestId}`);
        const statusUrl = `https://queue.fal.run/fal-ai/luma-dream-machine/image-to-video/requests/${requestId}`;
        let attempts = 0;
        const maxAttempts = 60; // 2 minutes maximum wait
        while (attempts < maxAttempts) {
            const statusResponse = await fetch(statusUrl, {
                headers: {
                    'Authorization': `Key ${apiKey}`,
                },
            });
            if (!statusResponse.ok) {
                throw new Error(`Fal.ai status check failed: ${statusResponse.status}`);
            }
            const statusData = await statusResponse.json();
            if (statusData.status === 'COMPLETED') {
                const videoUrl = statusData.outputs?.video?.url;
                if (!videoUrl) {
                    throw new Error('Fal.ai output contains no video URL');
                }
                console.log(`✅ Real video generated successfully via Fal.ai: ${videoUrl}`);
                return videoUrl;
            }
            if (statusData.status === 'FAILED') {
                throw new Error(`Fal.ai generation failed: ${statusData.error || 'unknown error'}`);
            }
            await new Promise((resolve) => setTimeout(resolve, 2000));
            attempts++;
        }
        throw new Error('Fal.ai request timed out');
    }
    catch (error) {
        console.error('❌ Fal.ai video generation failed:', error.message);
        console.warn('⚠️ Falling back to stock simulated video.');
        return getStockVideo(sector);
    }
}
function getStockVideo(sector) {
    switch (sector) {
        case client_1.SectorType.textile:
            return 'https://assets.mixkit.co/videos/preview/mixkit-bag-in-front-of-a-woman-spinning-33061-large.mp4';
        case client_1.SectorType.jewelry:
        case client_1.SectorType.beauty:
            return 'https://assets.mixkit.co/videos/preview/mixkit-fashion-woman-with-silver-glitter-makeup-40156-large.mp4';
        case client_1.SectorType.food:
            return 'https://assets.mixkit.co/videos/preview/mixkit-serving-pizza-on-a-plate-close-up-49071-large.mp4';
        case client_1.SectorType.electronics:
        case client_1.SectorType.furniture:
        default:
            return 'https://assets.mixkit.co/videos/preview/mixkit-shoes-in-front-of-a-neon-sign-34284-large.mp4';
    }
}
