import { Jimp } from 'jimp';
import { BackgroundStyle } from '../pipeline/platform.prompts';

type RGB = { r: number; g: number; b: number };

// Her stil icin duvar (ust→alt gradyan) + zemin rengi. Kompozit zaten urunu
// alt ucte (surfaceY≈0.78) zemine oturtup temas golgesi ekledigi icin iki-tonlu
// "duvar + zemin" arka plan inandirici bir studyo gorunumu verir.
const PALETTES: Record<string, { wallTop: RGB; wallBottom: RGB; floor: RGB }> = {
  studio_white:   { wallTop: { r: 246, g: 247, b: 249 }, wallBottom: { r: 226, g: 229, b: 234 }, floor: { r: 208, g: 212, b: 219 } },
  studio_dark:    { wallTop: { r: 42, g: 44, b: 52 },    wallBottom: { r: 26, g: 27, b: 33 },    floor: { r: 17, g: 18, b: 22 } },
  nature_outdoor: { wallTop: { r: 210, g: 232, b: 222 }, wallBottom: { r: 178, g: 210, b: 196 }, floor: { r: 146, g: 180, b: 164 } },
  lifestyle:      { wallTop: { r: 244, g: 237, b: 226 }, wallBottom: { r: 226, g: 213, b: 195 }, floor: { r: 202, g: 186, b: 163 } },
  minimalist:     { wallTop: { r: 250, g: 250, b: 251 }, wallBottom: { r: 237, g: 238, b: 240 }, floor: { r: 222, g: 223, b: 227 } },
  ai_generated:   { wallTop: { r: 126, g: 92, b: 214 },  wallBottom: { r: 86, g: 118, b: 220 },  floor: { r: 56, g: 76, b: 152 } },
};

function lerp(a: RGB, b: RGB, t: number): RGB {
  return {
    r: a.r + (b.r - a.r) * t,
    g: a.g + (b.g - a.g) * t,
    b: a.b + (b.b - a.b) * t,
  };
}

function clampByte(v: number): number {
  return Math.max(0, Math.min(255, Math.round(v)));
}

/**
 * Pollinations erisilemediginde kullanilan, %100 yerel/ucretsiz/kotasiz studyo
 * arka plani. Urun kesimi bunun uzerine kompozit edilir; boylece arka plan uretimi
 * basarisiz olsa bile sonuc duz orijinal degil, temiz studyo sahnesi olur.
 */
export async function generateLocalBackdrop(
  width: number,
  height: number,
  style: BackgroundStyle
): Promise<Buffer> {
  const startTime = Date.now();
  const p = PALETTES[style] || PALETTES.studio_white;
  const image = new Jimp({ width, height, color: 0xffffffff });
  const floorY = Math.round(height * 0.78);
  // Urunun arkasina denk gelen yumusak radyal isik merkezi (studyo spot hissi).
  const glowX = width / 2;
  const glowY = height * 0.42;
  const glowRadius = width * 0.62;

  image.scan(0, 0, width, height, function (this: any, x: number, y: number, idx: number) {
    let c: RGB;
    if (y < floorY) {
      c = lerp(p.wallTop, p.wallBottom, y / Math.max(1, floorY));
    } else {
      const t = (y - floorY) / Math.max(1, height - floorY);
      c = lerp(p.wallBottom, p.floor, Math.min(1, t * 1.25));
    }
    // Radyal stüdyo ışığı: merkeze yakin pikselleri hafifce aydinlat (düz görünmesin).
    const dist = Math.sqrt((x - glowX) ** 2 + (y - glowY) ** 2) / glowRadius;
    const glow = Math.max(0, 1 - dist) * 0.16; // merkez +%16'ya kadar parlaklik
    // Kenar vinyeti: kenarlar bir tik koyu.
    const dx = (x - width / 2) / (width / 2);
    const vignette = 1 - 0.06 * dx * dx;
    const factor = vignette * (1 + glow);
    this.bitmap.data[idx] = clampByte(c.r * factor);
    this.bitmap.data[idx + 1] = clampByte(c.g * factor);
    this.bitmap.data[idx + 2] = clampByte(c.b * factor);
    this.bitmap.data[idx + 3] = 255;
  });

  console.log(`🖼️ Local studio backdrop generated (${width}x${height}, style=${style}) in ${Date.now() - startTime}ms`);
  return image.getBuffer('image/jpeg');
}
