// SnapKOBİ uygulama ikonu üreteci (Jimp).
// Konsept: mor gradyan + beyaz KAMERA, lensi AI sparkle. "Snap (ürün fotoğrafı) + AI".
// Ayrica adaptive launcher sonucunu (gradyan+kamera+daire maske) onizleme olarak uretir.
const { Jimp } = require('jimp');
const path = require('path');
const fs = require('fs');

const SIZE = 1024;
const C = (SIZE - 1) / 2;
const OUT_DIR = path.resolve(__dirname, '../../SnapKOBI/assets/icon');

const DARK = { r: 45, g: 14, b: 110 };
const MID = { r: 92, g: 45, b: 184 };
const LIGHT = { r: 123, g: 63, b: 228 };

const lerp = (a, b, t) => ({ r: a.r + (b.r - a.r) * t, g: a.g + (b.g - a.g) * t, b: a.b + (b.b - a.b) * t });
const clampByte = (v) => Math.max(0, Math.min(255, Math.round(v)));
const clamp01 = (v) => Math.max(0, Math.min(1, v));

function gradientAt(x, y) {
  const t = (x + y) / (2 * (SIZE - 1));
  return t < 0.5 ? lerp(DARK, MID, t / 0.5) : lerp(MID, LIGHT, (t - 0.5) / 0.5);
}
function roundedAlpha(x, y, r) {
  const half = SIZE / 2;
  const dx = Math.max(Math.abs(x - C) - (half - r), 0);
  const dy = Math.max(Math.abs(y - C) - (half - r), 0);
  return clamp01((r - Math.sqrt(dx * dx + dy * dy)) / 1.5 + 0.5);
}
function rrectAlpha(x, y, left, top, right, bottom, r) {
  const cx = (left + right) / 2, cy = (top + bottom) / 2;
  const hw = (right - left) / 2 - r, hh = (bottom - top) / 2 - r;
  const dx = Math.max(Math.abs(x - cx) - hw, 0);
  const dy = Math.max(Math.abs(y - cy) - hh, 0);
  return clamp01(0.5 - (Math.sqrt(dx * dx + dy * dy) - r) / 1.5);
}
function circleAlpha(x, y, cx, cy, R) {
  return clamp01(0.5 - (Math.sqrt((x - cx) ** 2 + (y - cy) ** 2) - R) / 1.5);
}
function sparkleAlpha(x, y, cx, cy, s) {
  const X = Math.abs((x - cx) / s), Y = Math.abs((y - cy) / s);
  if (X > 1.2 || Y > 1.2) return 0;
  return clamp01((1 - (Math.pow(X, 2 / 3) + Math.pow(Y, 2 / 3))) / 0.07);
}

// Ortalanmis, dengeli kamera. cy: dikey merkez.
function cameraWhiteAlpha(x, y) {
  const cy = 540;
  const bL = 244, bR = 780, bT = 360, bB = 728, bRad = 64;   // govde
  const hL = 318, hR = 452, hT = 312, hB = 362, hRad = 16;   // vizör
  const lcx = 512, lcy = cy + 4, outerR = 138, innerR = 92;  // lens
  const shx = 690, shy = 422, shR = 24;                      // deklanşör deligi

  const body = Math.max(rrectAlpha(x, y, bL, bT, bR, bB, bRad), rrectAlpha(x, y, hL, hT, hR, hB, hRad));
  const hole = circleAlpha(x, y, lcx, lcy, innerR);
  const shutter = circleAlpha(x, y, shx, shy, shR);
  let white = body * (1 - hole) * (1 - shutter);
  white = Math.max(white, sparkleAlpha(x, y, lcx, lcy, 66)); // AI sparkle lens icinde
  return clamp01(white);
}

function blendWhite(d, i, a) {
  if (a <= 0) return;
  d[i] = clampByte(d[i] * (1 - a) + 255 * a);
  d[i + 1] = clampByte(d[i + 1] * (1 - a) + 255 * a);
  d[i + 2] = clampByte(d[i + 2] * (1 - a) + 255 * a);
  // ALPHA da yukseltilmeli; aksi halde seffaf foreground'da kamera "beyaz ama gorunmez" kalir.
  d[i + 3] = clampByte(d[i + 3] + (255 - d[i + 3]) * a);
}
function buildGradient(rounded) {
  const img = new Jimp({ width: SIZE, height: SIZE, color: 0x00000000 });
  const r = SIZE * 0.18;
  img.scan(0, 0, SIZE, SIZE, function (x, y, idx) {
    const c = gradientAt(x, y);
    this.bitmap.data[idx] = clampByte(c.r);
    this.bitmap.data[idx + 1] = clampByte(c.g);
    this.bitmap.data[idx + 2] = clampByte(c.b);
    this.bitmap.data[idx + 3] = clampByte((rounded ? roundedAlpha(x, y, r) : 1) * 255);
  });
  return img;
}
function drawCamera(img) {
  img.scan(0, 0, SIZE, SIZE, function (x, y, idx) {
    blendWhite(this.bitmap.data, idx, cameraWhiteAlpha(x, y));
  });
}

async function main() {
  fs.mkdirSync(OUT_DIR, { recursive: true });

  const main = buildGradient(true);
  drawCamera(main);
  await main.write(path.join(OUT_DIR, 'app_icon.png'));

  const bg = buildGradient(false);
  await bg.write(path.join(OUT_DIR, 'app_icon_background.png'));

  const fg = new Jimp({ width: SIZE, height: SIZE, color: 0x00000000 });
  drawCamera(fg);
  await fg.write(path.join(OUT_DIR, 'app_icon_foreground.png'));

  // ── Onizleme: launcher'in gosterecegi adaptive sonuc ──
  // bg (tam gradyan) + fg %16 inset ile + daire maske
  const preview = buildGradient(false);
  const fgInset = fg.clone().resize({ w: Math.round(SIZE * 0.68), h: Math.round(SIZE * 0.68) });
  const off = Math.round((SIZE - SIZE * 0.68) / 2);
  preview.composite(fgInset, off, off);
  preview.scan(0, 0, SIZE, SIZE, function (x, y, idx) {
    // daire disini seffaf yap (launcher circle mask simulasyonu)
    const d = Math.sqrt((x - C) ** 2 + (y - C) ** 2);
    if (d > SIZE / 2 - 2) this.bitmap.data[idx + 3] = 0;
  });
  await preview.write(path.join(OUT_DIR, 'preview_adaptive.png'));

  console.log('✅ Ikonlar + önizleme üretildi →', OUT_DIR);
}

main().catch((e) => { console.error(e); process.exit(1); });
