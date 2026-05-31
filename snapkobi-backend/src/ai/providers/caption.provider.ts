import { generateCaptionWithGemini } from './gemini.provider';
import { generateCaptionWithOpenAi } from './openai.provider';
import { AiProviderConfig } from './provider-config';

export async function generateCaption(
  prompt: string,
  config?: AiProviderConfig
): Promise<{ caption: string; hashtags: string[] }> {
  const provider = config?.provider.toLowerCase();
  if (provider === 'openai' || provider === 'chatgpt' || provider === 'gpt') {
    return generateCaptionWithOpenAi(prompt, config!);
  }

  return generateCaptionWithGemini(prompt, config?.apiKey, config?.activeModel);
}
