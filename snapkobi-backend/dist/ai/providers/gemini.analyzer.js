"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.analyzeProductImage = analyzeProductImage;
const env_1 = require("../../config/env");
const gemini_config_1 = require("../../lib/ai/gemini-config");
const IMAGE_ANALYSIS_SYSTEM_PROMPT = `
Sen bir e-ticaret ürün fotoğrafı uzmanısın. Yüklenen görseli analiz et ve JSON formatında döndür.

KURALLAR:
- Sadece JSON döndür, başka metin ekleme
- Türkçe değerler kullan
- productType için kısa ve net ol (max 3 kelime)
- suggestedCategory SADECE şu değerlerden biri olabilir: fashion, electronics, food, beauty, home, sports, toys, automotive, other

JSON ŞEMASI:
{
  "productType": "string",
  "dominantColors": ["string"],
  "backgroundType": "string",
  "productCondition": "string",
  "lightingQuality": "string",
  "suggestedCategory": "string",
  "rawDescription": "string (max 2 cümle)"
}
`;
async function analyzeProductImage(imageUrl, customApiKey, customModel) {
    const apiKey = customApiKey || env_1.env.GOOGLE_AI_API_KEY;
    if (!apiKey) {
        console.warn('⚠️ No GOOGLE_AI_API_KEY found for analyzer. Returning mock product analysis.');
        return getMockAnalysis();
    }
    const model = customModel || (0, gemini_config_1.getGeminiModel)();
    const url = (0, gemini_config_1.buildGeminiEndpoint)(model, apiKey);
    try {
        console.log(`🔍 Downloading image for Gemini analysis: ${imageUrl}`);
        const downloadRes = await fetch(imageUrl);
        if (!downloadRes.ok) {
            throw new Error(`Failed to download image from URL: ${imageUrl}, status: ${downloadRes.status}`);
        }
        const arrayBuffer = await downloadRes.arrayBuffer();
        const base64Data = Buffer.from(arrayBuffer).toString('base64');
        const mimeType = downloadRes.headers.get('content-type') || 'image/jpeg';
        console.log(`🤖 Invoking Gemini Multimodal Visual Analysis using model ${model}...`);
        const body = {
            contents: [
                {
                    parts: [
                        {
                            inlineData: {
                                mimeType,
                                data: base64Data,
                            },
                        },
                        { text: IMAGE_ANALYSIS_SYSTEM_PROMPT },
                    ],
                },
            ],
            generationConfig: {
                responseMimeType: 'application/json',
            },
        };
        const data = await (0, gemini_config_1.executeGeminiRequest)(url, body, model);
        const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
        if (!text) {
            throw new Error('Gemini API analyzer returned empty text');
        }
        try {
            const parsed = JSON.parse(text.replace(/```json|```/g, '').trim());
            console.log('✅ Gemini Visual Analysis completed:', parsed);
            return parsed;
        }
        catch (jsonErr) {
            console.error('❌ Failed to parse Gemini Visual Analysis response as JSON. Raw response content:', text);
            throw jsonErr;
        }
    }
    catch (error) {
        console.error('❌ Gemini Visual Analysis failed:', error.message);
        return getMockAnalysis();
    }
}
function getMockAnalysis() {
    return {
        productType: 'ürün',
        dominantColors: ['çok renkli'],
        backgroundType: 'düz zemin',
        productCondition: 'tek ürün',
        lightingQuality: 'iyi aydınlatma',
        suggestedCategory: 'other',
        rawDescription: 'Mock görsel analizi kullanıldı. Lütfen API anahtarlarını kontrol edin.',
    };
}
