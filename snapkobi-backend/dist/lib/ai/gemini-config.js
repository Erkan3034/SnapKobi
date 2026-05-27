"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DEFAULT_GEMINI_MODEL = exports.SUPPORTED_GEMINI_MODELS = void 0;
exports.getGeminiModel = getGeminiModel;
exports.buildGeminiEndpoint = buildGeminiEndpoint;
exports.executeGeminiRequest = executeGeminiRequest;
const env_1 = require("../../config/env");
exports.SUPPORTED_GEMINI_MODELS = [
    'gemini-2.5-flash',
    'gemini-2.5-pro',
    'gemini-2.0-flash',
];
exports.DEFAULT_GEMINI_MODEL = 'gemini-2.5-flash';
/**
 * Validates the Gemini model specified in environment variables.
 * Falls back to DEFAULT_GEMINI_MODEL with a warning if the configured model is invalid.
 */
function getGeminiModel() {
    const configuredModel = env_1.env.GEMINI_MODEL;
    if (!configuredModel) {
        return exports.DEFAULT_GEMINI_MODEL;
    }
    if (exports.SUPPORTED_GEMINI_MODELS.includes(configuredModel)) {
        return configuredModel;
    }
    console.warn(`⚠️ Invalid Gemini model configured: "${configuredModel}". Falling back to "${exports.DEFAULT_GEMINI_MODEL}".`);
    return exports.DEFAULT_GEMINI_MODEL;
}
/**
 * Builds the Generative Language API endpoint URL for a given model and API key.
 */
function buildGeminiEndpoint(model, apiKey) {
    return `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;
}
/**
 * Executes a POST request to the Google Gemini API with a built-in timeout and exponential backoff retry.
 * Retries on transient errors: 429 (rate limits), 500 (internal server errors), 503 (service unavailable).
 */
async function executeGeminiRequest(url, body, model, options = {}) {
    const timeoutMs = options.timeoutMs ?? 30000; // 30 seconds default
    const maxRetries = options.maxRetries ?? 3;
    const initialDelayMs = options.initialDelayMs ?? 1000;
    let attempt = 0;
    while (true) {
        attempt++;
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeoutMs);
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(body),
                signal: controller.signal,
            });
            clearTimeout(timeoutId);
            if (!response.ok) {
                const errorBody = await response.text();
                console.error('❌ Gemini API Error:', {
                    status: response.status,
                    body: errorBody,
                    model,
                    attempt,
                });
                const isRetriable = [429, 500, 503].includes(response.status);
                if (isRetriable && attempt <= maxRetries) {
                    const delay = initialDelayMs * Math.pow(2, attempt - 1);
                    console.warn(`⚠️ Retriable status ${response.status}. Retrying in ${delay}ms... (Attempt ${attempt}/${maxRetries})`);
                    await new Promise((resolve) => setTimeout(resolve, delay));
                    continue;
                }
                throw new Error(`Gemini API responded with status ${response.status}: ${errorBody}`);
            }
            const json = await response.json();
            return json;
        }
        catch (error) {
            clearTimeout(timeoutId);
            const isTimeout = error.name === 'AbortError';
            const errorMessage = isTimeout
                ? 'Request timed out after 30 seconds'
                : error.message;
            console.error(`❌ Gemini Request failed (Attempt ${attempt}/${maxRetries}):`, errorMessage);
            const isNetworkOrTimeout = isTimeout ||
                error.code === 'ECONNRESET' ||
                error.message.includes('fetch');
            if (isNetworkOrTimeout && attempt <= maxRetries) {
                const delay = initialDelayMs * Math.pow(2, attempt - 1);
                console.warn(`⚠️ Network/Timeout failure. Retrying in ${delay}ms... (Attempt ${attempt}/${maxRetries})`);
                await new Promise((resolve) => setTimeout(resolve, delay));
                continue;
            }
            throw new Error(errorMessage);
        }
    }
}
