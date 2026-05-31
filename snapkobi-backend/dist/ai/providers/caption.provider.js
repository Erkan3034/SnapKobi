"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateCaption = generateCaption;
const gemini_provider_1 = require("./gemini.provider");
const openai_provider_1 = require("./openai.provider");
async function generateCaption(prompt, config) {
    const provider = config?.provider.toLowerCase();
    if (provider === 'openai' || provider === 'chatgpt' || provider === 'gpt') {
        return (0, openai_provider_1.generateCaptionWithOpenAi)(prompt, config);
    }
    return (0, gemini_provider_1.generateCaptionWithGemini)(prompt, config?.apiKey, config?.activeModel);
}
