import { uploadToSupabaseStorage } from './storage.helper';
import { env } from '../../config/env';
import { AiProviderConfig } from './provider-config';

export async function generateImageWithPollinations(
  prompt: string,
  generationId: string,
  config?: AiProviderConfig
): Promise<string> {
  try {
    const seed = Math.floor(Math.random() * 1000000);
    const width = 1024;
    const height = 1024;
    const apiKey = config?.apiKey || env.POLLINATIONS_KEY;
    const configuredUrl = config?.apiUrl;
    const baseUrl = configuredUrl && (apiKey || !configuredUrl.includes('gen.pollinations.ai'))
      ? configuredUrl
      : (apiKey
      ? 'https://gen.pollinations.ai/image'
      : 'https://image.pollinations.ai/prompt');
    const pollinationsUrl = new URL(`${baseUrl.replace(/\/$/, '')}/${encodeURIComponent(prompt)}`);
    pollinationsUrl.searchParams.set('width', String(width));
    pollinationsUrl.searchParams.set('height', String(height));
    pollinationsUrl.searchParams.set('nologo', 'true');
    pollinationsUrl.searchParams.set('seed', String(seed));
    // Model her zaman gonderilir (ucretsiz endpoint de destekler). Eski/zayif varsayilan
    // degerleri ('zimage'/'pollinations') yuksek kaliteli ve metin halusinasyonu daha az
    // olan 'flux'a haritala. Acik bir iyi model secilmisse ona saygi goster.
    const rawModel = (config?.activeModel || '').toLowerCase();
    const model = (!rawModel || rawModel === 'zimage' || rawModel === 'pollinations')
      ? 'flux'
      : config!.activeModel;
    pollinationsUrl.searchParams.set('model', model);

    console.log(`🎨 Fetching image from Pollinations AI: ${pollinationsUrl}`);
    const response = await fetch(pollinationsUrl, {
      headers: apiKey ? { Authorization: `Bearer ${apiKey}` } : {},
      signal: AbortSignal.timeout(60000),
    });

    if (!response.ok) {
      throw new Error(`Pollinations AI responded with status: ${response.status}`);
    }

    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    const fileName = `images/${generationId}.jpg`;
    const publicUrl = await uploadToSupabaseStorage(buffer, fileName);

    if (publicUrl) {
      console.log(`✅ Image uploaded to Supabase Storage: ${publicUrl}`);
      return publicUrl;
    }

    // Fallback if storage upload failed
    console.warn('⚠️ Storage upload failed, falling back to direct Pollinations URL');
    return pollinationsUrl.toString();
  } catch (error: any) {
    console.error('❌ Pollinations Image generation failed:', error.message);
    throw error;
  }
}
