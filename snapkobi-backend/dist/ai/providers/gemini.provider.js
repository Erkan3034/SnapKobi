"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateCaptionWithGemini = generateCaptionWithGemini;
const env_1 = require("../../config/env");
const gemini_config_1 = require("../../lib/ai/gemini-config");
async function generateCaptionWithGemini(prompt, customApiKey) {
    const apiKey = customApiKey || env_1.env.GOOGLE_AI_API_KEY;
    if (!apiKey) {
        console.warn('⚠️ No GOOGLE_AI_API_KEY found. Falling back to mock caption generator.');
        return generateMockCaption(prompt);
    }
    const model = (0, gemini_config_1.getGeminiModel)();
    const url = (0, gemini_config_1.buildGeminiEndpoint)(model, apiKey);
    try {
        const jsonPrompt = `${prompt}\n\nYou MUST return the response strictly as a JSON object with the following keys:\n{\n  "caption": "Your generated platform-specific caption text (String)",\n  "hashtags": ["list", "of", "hashtags"] (Array of Strings)\n}`;
        const body = {
            contents: [{ parts: [{ text: jsonPrompt }] }],
            generationConfig: {
                responseMimeType: 'application/json',
                responseSchema: {
                    type: 'OBJECT',
                    properties: {
                        caption: { type: 'STRING' },
                        hashtags: {
                            type: 'ARRAY',
                            items: { type: 'STRING' }
                        }
                    },
                    required: ['caption', 'hashtags']
                }
            },
        };
        const data = await (0, gemini_config_1.executeGeminiRequest)(url, body, model);
        const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
        if (!text) {
            throw new Error('Gemini API returned an empty response');
        }
        try {
            const result = JSON.parse(text);
            return {
                caption: result.caption || '',
                hashtags: result.hashtags || [],
            };
        }
        catch (jsonErr) {
            console.error('❌ Failed to parse Gemini response as JSON. Raw response content:', text);
            throw jsonErr;
        }
    }
    catch (error) {
        console.error('❌ Gemini caption generation failed:', error.message);
        console.warn('⚠️ Falling back to mock caption generator.');
        return generateMockCaption(prompt);
    }
}
function generateMockCaption(prompt) {
    const isInstagram = prompt.toLowerCase().includes('instagram');
    const isTrendyol = prompt.toLowerCase().includes('trendyol');
    let caption = 'Yeni sezon koleksiyonumuz sizlerle! 🌟 Şıklığı ve konforu bir arada sunan özel tasarım ürünümüzü şimdi keşfedin. Detaylı bilgi ve sipariş için DM üzerinden iletişime geçebilirsiniz. Sınırlı stok!';
    let hashtags = ['#yenisezon', '#butik', '#tasarim', '#kalite', '#moda'];
    if (isTrendyol) {
        caption = 'Trendyol mağazamızda haftanın yıldızı! ⭐ Kaçırılmayacak fırsatlar ve sepet indirimleriyle şimdi satın alın. Profilimizdeki linkten hemen ulaşabilirsiniz.';
        hashtags = ['#trendyol', '#firsat', '#indirim', '#alisveris'];
    }
    else if (isInstagram) {
        caption = 'Hayalinizdeki tarz şimdi bir tık uzağınızda! ✨ Sınırlı sayıda üretilen bu benzersiz parçayı kaçırmayın. Detaylar ve sipariş için profilimizi ziyaret edin veya DM gönderin. 📥';
        hashtags = ['#instagram', '#tarz', '#kombin', '#kadinmoda'];
    }
    return { caption, hashtags };
}
