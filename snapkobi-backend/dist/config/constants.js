"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DEFAULT_APP_SETTINGS = exports.DEFAULT_AI_CONFIGS = void 0;
exports.DEFAULT_AI_CONFIGS = [
    {
        taskType: 'image',
        provider: 'pollinations',
        activeModel: 'zimage',
        apiUrl: 'https://gen.pollinations.ai/image',
    },
    {
        taskType: 'analysis',
        provider: 'gemini',
        activeModel: 'gemini-2.5-flash',
        apiUrl: 'https://generativelanguage.googleapis.com',
    },
    {
        taskType: 'caption',
        provider: 'gemini',
        activeModel: 'gemini-2.5-flash',
        apiUrl: 'https://generativelanguage.googleapis.com',
    },
    {
        taskType: 'video',
        provider: 'pollinations',
        activeModel: 'ltx-2',
        apiUrl: 'https://gen.pollinations.ai/video',
    },
];
exports.DEFAULT_APP_SETTINGS = [
    {
        key: 'credit_rules',
        value: {
            plans: { free: 5, starter: 100, pro: 500 },
            costs: { image: 1, video: 1, caption: 0 },
        },
    },
];
