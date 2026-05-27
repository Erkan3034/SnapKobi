"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateImageWithPollinations = generateImageWithPollinations;
const storage_helper_1 = require("./storage.helper");
async function generateImageWithPollinations(prompt, generationId) {
    try {
        const seed = Math.floor(Math.random() * 1000000);
        const width = 1024;
        const height = 1024;
        const pollinationsUrl = `https://image.pollinations.ai/prompt/${encodeURIComponent(prompt)}?width=${width}&height=${height}&nologo=true&seed=${seed}`;
        console.log(`🎨 Fetching image from Pollinations AI: ${pollinationsUrl}`);
        const response = await fetch(pollinationsUrl);
        if (!response.ok) {
            throw new Error(`Pollinations AI responded with status: ${response.status}`);
        }
        const arrayBuffer = await response.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        const fileName = `images/${generationId}.jpg`;
        const publicUrl = await (0, storage_helper_1.uploadToSupabaseStorage)(buffer, fileName);
        if (publicUrl) {
            console.log(`✅ Image uploaded to Supabase Storage: ${publicUrl}`);
            return publicUrl;
        }
        // Fallback if storage upload failed
        console.warn('⚠️ Storage upload failed, falling back to direct Pollinations URL');
        return pollinationsUrl;
    }
    catch (error) {
        console.error('❌ Pollinations Image generation failed:', error.message);
        throw error;
    }
}
