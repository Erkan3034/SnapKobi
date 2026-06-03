import convert from 'heic-convert';
import { Jimp } from 'jimp';

/**
 * Buyuk gorselleri isleme oncesi kucultur (bellek/CPU tasarrufu). 12MP telefon
 * fotograflari arka plan kaldirma + kompozitte yuzlerce MB tutabiliyor ve dusuk
 * bellekli sunucuda OOM'a yol aciyor. Final urun zaten <600px kullanildigi icin
 * uzun kenari maxEdge'e indirmek kaliteyi bozmaz.
 */
export async function downscaleToMaxEdge(buffer: Buffer, maxEdge = 1440): Promise<Buffer> {
  try {
    const img = await Jimp.read(buffer);
    const { width, height } = img.bitmap;
    const longest = Math.max(width, height);
    if (longest <= maxEdge) return buffer;
    const scale = maxEdge / longest;
    img.resize({ w: Math.round(width * scale), h: Math.round(height * scale) });
    return await img.getBuffer('image/jpeg');
  } catch {
    // Cozulemezse orijinali dondur (downstream kendi hatasini verir).
    return buffer;
  }
}

/** content-type veya url uzantisindan HEIC/HEIF tespit eder. */
export function isHeic(contentType?: string | null, url?: string): boolean {
  const ct = (contentType || '').toLowerCase();
  if (ct.includes('heic') || ct.includes('heif')) return true;
  const u = (url || '').toLowerCase().split('?')[0];
  return u.endsWith('.heic') || u.endsWith('.heif');
}

/**
 * Girdi gorselini downstream adimlarin (arka plan kaldirma, kompozit, ffmpeg, Flutter
 * render) hepsinin destekledigi JPEG'e cevirir. HEIC/HEIF ise heic-convert ile decode
 * eder; aksi halde (jpg/png/webp) oldugu gibi birakir.
 */
export async function normalizeToJpeg(
  buffer: Buffer,
  contentType?: string | null,
  url?: string
): Promise<{ buffer: Buffer; contentType: string }> {
  if (isHeic(contentType, url)) {
    const out = await convert({ buffer, format: 'JPEG', quality: 0.92 });
    return { buffer: Buffer.from(out), contentType: 'image/jpeg' };
  }
  return { buffer, contentType: contentType || 'image/jpeg' };
}
