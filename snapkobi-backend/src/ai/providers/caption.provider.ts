import { generateCaptionWithGemini } from './gemini.provider';
import { generateCaptionWithOpenAi } from './openai.provider';
import { AiProviderConfig } from './provider-config';

export async function generateCaption(
  prompt: string,
  config?: AiProviderConfig
): Promise<{ caption: string; hashtags: string[] }> {
  const provider = config?.provider.toLowerCase();
  if (provider === 'openai' || provider === 'chatgpt' || provider === 'gpt') {
    try {
      return await generateCaptionWithOpenAi(prompt, config!);
    } catch (e: any) {
      // OpenAI anahtari yok/hata → ucretsiz Gemini'ye dus (Gemini'nin kendi mock fallback'i var).
      console.warn('⚠️ OpenAI caption failed, falling back to Gemini:', e.message);
    }
  }

  return generateCaptionWithGemini(prompt, config?.apiKey, config?.activeModel);
}
