import { env } from '../../config/env';

/**
 * Pixazo (Azure API Management) SDXL ile gorsel uretir.
 *
 * Sozlesme (portaldan dogrulandi):
 *   POST https://gateway.pixazo.ai/getImage/v1/getSDXLImage
 *   Header: Ocp-Apim-Subscription-Key: <key>, Content-Type: application/json
 *   Body:   { prompt, negative_prompt, width, height, num_steps, guidance_scale, seed }
 *
 * Yanit hem ham gorsel (image/*) hem de JSON (base64/url alani) olabilir; ikisi de
 * desteklenir. Basarisizlikta hata firlatir → orchestrator Pollinations → yerel
 * arka plan zincirine duser.
 *
 * Gerekli env:
 *   PIXAZO_API_KEY  → "Ocp-Apim-Subscription-Key" abonelik anahtari (ZORUNLU)
 *   PIXAZO_API_URL  → opsiyonel; verilmezse varsayilan gateway endpoint kullanilir
 */
const DEFAULT_PIXAZO_URL = 'https://gateway.pixazo.ai/getImage/v1/getSDXLImage';

const NO_TEXT_NEGATIVE =
  'text, letters, words, numbers, typography, captions, labels, logos, signs, watermarks, writing, ' +
  'low-quality, blurry, distorted, deformed, extra objects, products, bottles, packages, hands, people, ' +
  'cluttered, busy background, harsh lighting, unnatural colors';

export function isPixazoConfigured(): boolean {
  return Boolean(env.PIXAZO_API_KEY);
}

export async function generatePixazoBackdrop(prompt: string): Promise<Buffer> {
  if (!isPixazoConfigured()) {
    throw new Error('Pixazo yapilandirilmamis (PIXAZO_API_KEY eksik)');
  }

  const endpoint = (env.PIXAZO_API_URL && env.PIXAZO_API_URL.trim()) || DEFAULT_PIXAZO_URL;
  // SDXL kisa/temiz prompt ister; cok uzun paragraflar (CLIP ~77 token) 500'e yol
  // acabiliyor. Satir sonlarini sadelestir ve makul uzunluga kirp. Metin engeli zaten
  // negative_prompt'ta oldugu icin pozitif prompt yalnizca sahneyi tarif etsin.
  const cleanPrompt = prompt.replace(/\s+/g, ' ').trim().slice(0, 350);
  const body = {
    prompt: cleanPrompt,
    negative_prompt: NO_TEXT_NEGATIVE,
    // Portaldaki calisan ornek tam olarak bu degerleri kullaniyordu. num_steps>20
    // veya guidance>5 bu endpoint'te "500 Error processing request" uretiyor → birebir uy.
    width: 1024,
    height: 1024,
    num_steps: 20,
    guidance_scale: 5,
    seed: Math.floor(Math.random() * 1_000_000),
  };

  console.log(`🎨 Fetching image from Pixazo SDXL: ${endpoint}`);

  // 5xx/429 gecici hatalarinda kisa beklemeyle 2 kez daha dene.
  let response: Response | null = null;
  for (let attempt = 0; attempt < 3; attempt++) {
    response = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'Ocp-Apim-Subscription-Key': env.PIXAZO_API_KEY as string,
        'Content-Type': 'application/json',
        Accept: 'image/*, application/json',
        'Cache-Control': 'no-cache',
      },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(90000),
    });
    if (response.ok) break;
    if ((response.status >= 500 || response.status === 429) && attempt < 2) {
      console.warn(`⏳ Pixazo ${response.status} — ${2 * (attempt + 1)}sn sonra tekrar denenecek (deneme ${attempt + 2}/3)...`);
      await new Promise((r) => setTimeout(r, 2000 * (attempt + 1)));
      continue;
    }
    break;
  }

  if (!response || !response.ok) {
    const errText = response ? await response.text().catch(() => '') : '';
    throw new Error(`Pixazo responded with status ${response?.status ?? 'no-response'}: ${errText.slice(0, 200)}`);
  }

  const contentType = response.headers.get('content-type') || '';

  // 1) Dogrudan gorsel byte'lari
  if (contentType.startsWith('image/')) {
    return Buffer.from(await response.arrayBuffer());
  }

  // 2) JSON yanit — base64 veya url alani ara
  if (contentType.includes('application/json')) {
    const json: any = await response.json();
    const base64 = findBase64(json);
    if (base64) {
      return Buffer.from(base64.replace(/^data:image\/\w+;base64,/, ''), 'base64');
    }
    const imageUrl = findImageUrl(json);
    if (imageUrl) {
      const imgRes = await fetch(imageUrl, { signal: AbortSignal.timeout(60000) });
      if (!imgRes.ok) throw new Error(`Pixazo image url fetch failed: ${imgRes.status}`);
      return Buffer.from(await imgRes.arrayBuffer());
    }
    throw new Error('Pixazo JSON yanitinda gorsel (base64/url) bulunamadi');
  }

  // 3) content-type belirsiz → byte olarak dene
  const buf = Buffer.from(await response.arrayBuffer());
  if (buf.length > 1024) return buf;
  throw new Error(`Pixazo beklenmeyen yanit tipi: ${contentType}`);
}

function findBase64(obj: any): string | null {
  if (!obj || typeof obj !== 'object') return null;
  for (const key of ['image', 'image_base64', 'b64_json', 'base64', 'data', 'result', 'output', 'imageData']) {
    const v = obj[key];
    if (typeof v === 'string' && v.startsWith('data:image')) return v;
    if (typeof v === 'string' && v.length > 256 && /^[A-Za-z0-9+/=\s]+$/.test(v.slice(0, 80))) {
      return v;
    }
  }
  for (const v of Object.values(obj)) {
    if (Array.isArray(v) && v.length) {
      const found = findBase64(typeof v[0] === 'object' ? v[0] : { data: v[0] });
      if (found) return found;
    } else if (v && typeof v === 'object') {
      const found = findBase64(v);
      if (found) return found;
    }
  }
  return null;
}

function findImageUrl(obj: any): string | null {
  if (!obj || typeof obj !== 'object') return null;
  for (const key of ['url', 'image_url', 'imageUrl', 'output_url', 'result_url']) {
    const v = obj[key];
    if (typeof v === 'string' && v.startsWith('http')) return v;
  }
  for (const v of Object.values(obj)) {
    if (Array.isArray(v) && v.length) {
      const found = findImageUrl(typeof v[0] === 'string' ? { url: v[0] } : v[0]);
      if (found) return found;
    } else if (v && typeof v === 'object') {
      const found = findImageUrl(v);
      if (found) return found;
    }
  }
  return null;
}
