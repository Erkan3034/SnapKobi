"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateCaptionWithOpenAi = generateCaptionWithOpenAi;
const env_1 = require("../../config/env");
async function generateCaptionWithOpenAi(prompt, config) {
    const apiKey = config.apiKey || env_1.env.OPENAI_API_KEY;
    if (!apiKey) {
        throw new Error('OpenAI API key is not configured');
    }
    const response = await fetch(config.apiUrl || 'https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${apiKey}`,
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            model: config.activeModel || 'gpt-4.1-mini',
            messages: [
                {
                    role: 'system',
                    content: 'Return only valid JSON with caption and hashtags fields.',
                },
                { role: 'user', content: prompt },
            ],
            response_format: { type: 'json_object' },
        }),
    });
    if (!response.ok) {
        throw new Error(`OpenAI API responded with status ${response.status}: ${await response.text()}`);
    }
    const data = await response.json();
    const content = data.choices?.[0]?.message?.content;
    if (!content) {
        throw new Error('OpenAI API returned an empty response');
    }
    const parsed = JSON.parse(content);
    return {
        caption: parsed.caption || '',
        hashtags: Array.isArray(parsed.hashtags) ? parsed.hashtags : [],
    };
}
