// Kullanicinin source_logo.png'sinden SADECE "S" markasini cikarip uygulama ikonu uretir.
// (Alttaki "snapkobi" yazisi + slogan haric.) Arka plan lacivert korunur.
const { Jimp } = require('jimp');
const path = require('path');
const fs = require('fs');

const DIR = path.resolve(__dirname, '../../SnapKOBI/assets/icon');
const SRC = path.join(DIR, 'source_logo.png');
const SIZE = 1024;
const C = (SIZE - 1) / 2;
const NAVY = { r: 3, g: 18, b: 67 };

const clampByte = (v) => Math.max(0, Math.min(255, Math.round(v)));
const clamp01 = (v) => Math.max(0, Math.min(1, v));
const dist = (d, i) => Math.sqrt((d[i] - NAVY.r) ** 2 + (d[i + 1] - NAVY.g) ** 2 + (d[i + 2] - NAVY.b) ** 2);

function roundedAlpha(x, y, r) {
  const half = SIZE / 2;
  const dx = Math.max(Math.abs(x - C) - (half - r), 0);
  const dy = Math.max(Math.abs(y - C) - (half - r), 0);
  return clamp01((r - Math.sqrt(dx * dx + dy * dy)) / 1.5 + 0.5);
}

async function main() {
  const src = await Jimp.read(SRC);
  const W = src.bitmap.width, H = src.bitmap.height, d = src.bitmap.data;

  // 1) "S" markasinin bbox'i — yalnizca ust bolgede ara (yazi/slogan haric)
  const maxY = Math.round(H * 0.585);
  let minX = W, minY = H, maxX = -1, maxYY = -1;
  const TH = 55; // navy'den uzaklik esigi
  for (let y = 0; y < maxY; y++) {
    for (let x = 0; x < W; x++) {
      if (dist(d, (y * W + x) * 4) > TH) {
        if (x < minX) minX = x; if (x > maxX) maxX = x;
        if (y < minY) minY = y; if (y > maxYY) maxYY = y;
      }
    }
  }
  const pad = 16;
  minX = Math.max(0, minX - pad); minY = Math.max(0, minY - pad);
  maxX = Math.min(W - 1, maxX + pad); maxYY = Math.min(H - 1, maxYY + pad);
  const mw = maxX - minX + 1, mh = maxYY - minY + 1;
  console.log(`Mark bbox: x ${minX}..${maxX}, y ${minY}..${maxYY} (${mw}x${mh})`);

  // 2) Markayi kirp + arka plani seffaflastir (navy → alpha 0, kenarlar yumusak)
  const mark = src.clone().crop({ x: minX, y: minY, w: mw, h: mh });
  mark.scan(0, 0, mw, mh, function (x, y, i) {
    const a = clamp01((dist(this.bitmap.data, i) - 30) / 35);
    this.bitmap.data[i + 3] = clampByte(a * 255);
  });

  // Yardimci: markayi hedef orana olceklenmis ortalanmis sekilde bir tuvale bas
  const placeMark = (canvas, frac) => {
    const scale = (frac * SIZE) / Math.max(mw, mh);
    const nw = Math.round(mw * scale), nh = Math.round(mh * scale);
    const m = mark.clone().resize({ w: nw, h: nh });
    canvas.composite(m, Math.round((SIZE - nw) / 2), Math.round((SIZE - nh) / 2));
  };

  const navyHex = (clampByte(NAVY.r) << 24) | (clampByte(NAVY.g) << 16) | (clampByte(NAVY.b) << 8) | 0xff;

  // 3) Legacy / iOS: yuvarlatilmis lacivert kare + mark
  const main = new Jimp({ width: SIZE, height: SIZE, color: navyHex >>> 0 });
  const r = SIZE * 0.18;
  main.scan(0, 0, SIZE, SIZE, function (x, y, i) { this.bitmap.data[i + 3] = clampByte(roundedAlpha(x, y, r) * 255); });
  placeMark(main, 0.66);
  await main.write(path.join(DIR, 'app_icon.png'));

  // 4) Adaptive background: tam lacivert kare
  const bg = new Jimp({ width: SIZE, height: SIZE, color: navyHex >>> 0 });
  await bg.write(path.join(DIR, 'app_icon_background.png'));

  // 5) Adaptive foreground: seffaf + mark (guvenli bolge icin biraz kucuk)
  const fg = new Jimp({ width: SIZE, height: SIZE, color: 0x00000000 });
  placeMark(fg, 0.62);
  await fg.write(path.join(DIR, 'app_icon_foreground.png'));

  // 6) Onizleme: launcher adaptive sonuc (bg + fg %16 inset + daire maske)
  const preview = new Jimp({ width: SIZE, height: SIZE, color: navyHex >>> 0 });
  const inset = fg.clone().resize({ w: Math.round(SIZE * 0.68), h: Math.round(SIZE * 0.68) });
  const off = Math.round((SIZE - SIZE * 0.68) / 2);
  preview.composite(inset, off, off);
  preview.scan(0, 0, SIZE, SIZE, function (x, y, i) {
    if (Math.sqrt((x - C) ** 2 + (y - C) ** 2) > SIZE / 2 - 2) this.bitmap.data[i + 3] = 0;
  });
  await preview.write(path.join(DIR, 'preview_adaptive.png'));

  console.log('✅ Mark cikarildi + ikonlar uretildi →', DIR);
}

main().catch((e) => { console.error(e); process.exit(1); });
