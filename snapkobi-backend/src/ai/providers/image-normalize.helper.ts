import convert from 'heic-convert';

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
