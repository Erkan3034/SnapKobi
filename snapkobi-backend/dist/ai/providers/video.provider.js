"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateVideo = generateVideo;
const env_1 = require("../../config/env");
const storage_helper_1 = require("./storage.helper");
async function generateVideo(input) {
    const provider = (input.config?.provider || 'pollinations').toLowerCase();
    try {
        if (provider === 'fal' || provider === 'fal.ai') {
            return await generateWithFal(input);
        }
        return await generateWithPollinations(input);
    }
    catch (primaryError) {
        console.error(`❌ ${provider} video generation failed:`, primaryError.message);
        if (provider !== 'fal' && provider !== 'fal.ai' && env_1.env.FAL_KEY) {
            console.warn('⚠️ Retrying video generation with fal.ai fallback.');
            return generateWithFal({
                ...input,
                config: {
                    provider: 'fal',
                    activeModel: 'fal-ai/luma-dream-machine/image-to-video',
                    apiKey: env_1.env.FAL_KEY,
                },
            });
        }
        return null;
    }
}
async function generateWithPollinations(input) {
    const apiKey = input.config?.apiKey || env_1.env.POLLINATIONS_KEY;
    if (!apiKey) {
        throw new Error('Pollinations API key is not configured');
    }
    const baseUrl = input.config?.apiUrl || 'https://gen.pollinations.ai/video';
    const url = new URL(`${baseUrl.replace(/\/$/, '')}/${encodeURIComponent(input.prompt)}`);
    url.searchParams.set('model', input.config?.activeModel || 'ltx-2');
    url.searchParams.set('image', input.imageUrl);
    url.searchParams.set('duration', '5');
    url.searchParams.set('aspectRatio', '9:16');
    url.searchParams.set('safe', 'true');
    const response = await fetch(url, {
        headers: { Authorization: `Bearer ${apiKey}` },
    });
    if (!response.ok) {
        throw new Error(`Pollinations API responded with status ${response.status}: ${await response.text()}`);
    }
    return persistVideo(Buffer.from(await response.arrayBuffer()), input.generationId, url.toString());
}
async function generateWithFal(input) {
    const apiKey = input.config?.apiKey || env_1.env.FAL_KEY;
    if (!apiKey) {
        throw new Error('fal.ai API key is not configured');
    }
    const endpoint = input.config?.apiUrl ||
        `https://queue.fal.run/${input.config?.activeModel || 'fal-ai/luma-dream-machine/image-to-video'}`;
    const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
            Authorization: `Key ${apiKey}`,
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ image_url: input.imageUrl, prompt: input.prompt }),
    });
    if (!response.ok) {
        throw new Error(`fal.ai API responded with status ${response.status}: ${await response.text()}`);
    }
    const queueData = await response.json();
    if (!queueData.status_url || !queueData.response_url) {
        throw new Error('fal.ai returned an invalid queue response');
    }
    for (let attempts = 0; attempts < 180; attempts++) {
        const statusResponse = await fetch(queueData.status_url, {
            headers: { Authorization: `Key ${apiKey}` },
        });
        if (!statusResponse.ok) {
            throw new Error(`fal.ai status check failed: ${statusResponse.status}`);
        }
        const statusData = await statusResponse.json();
        if (statusData.status === 'COMPLETED') {
            const resultResponse = await fetch(queueData.response_url, {
                headers: { Authorization: `Key ${apiKey}` },
            });
            if (!resultResponse.ok) {
                throw new Error(`fal.ai result fetch failed: ${resultResponse.status}`);
            }
            const result = await resultResponse.json();
            const videoUrl = result.video?.url || result.outputs?.video?.url ||
                result.response?.video?.url || result.response?.outputs?.video?.url;
            if (!videoUrl) {
                throw new Error('fal.ai output contains no video URL');
            }
            const videoResponse = await fetch(videoUrl);
            if (!videoResponse.ok) {
                throw new Error(`fal.ai video download failed: ${videoResponse.status}`);
            }
            return persistVideo(Buffer.from(await videoResponse.arrayBuffer()), input.generationId, videoUrl);
        }
        await new Promise((resolve) => setTimeout(resolve, 2000));
    }
    throw new Error('fal.ai request timed out');
}
async function persistVideo(buffer, generationId, fallbackUrl) {
    return (await (0, storage_helper_1.uploadToSupabaseStorage)(buffer, `videos/${generationId}.mp4`, 'results', 'video/mp4')) || fallbackUrl;
}
