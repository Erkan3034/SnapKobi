import { Jimp } from 'jimp';

const ALPHA_THRESHOLD = 18;
const MIN_COMPONENT_RATIO = 0.008;

/**
 * Places a locally extracted product on a generated scene without redrawing it.
 * The cutout is trimmed, cleaned, grounded on the lower third, and given a
 * subtle contact shadow so it reads as a photographed object.
 */
export async function compositeProductOnBackground(
  productBuffer: Buffer,
  backgroundBuffer: Buffer
): Promise<Buffer> {
  console.log('Compositing cleaned product cutout onto generated background...');
  try {
    const startTime = Date.now();
    const background = await Jimp.read(backgroundBuffer);
    const product = await Jimp.read(productBuffer);

    cleanSmallAlphaComponents(product);
    const bounds = findAlphaBounds(product);
    if (!bounds) {
      throw new Error('Background removal returned an empty product cutout');
    }
    product.crop(bounds);
    retouchProduct(product);

    const bgWidth = background.bitmap.width;
    const bgHeight = background.bitmap.height;
    const prodWidth = product.bitmap.width;
    const prodHeight = product.bitmap.height;

    const maxWidth = bgWidth * 0.52;
    const maxHeight = bgHeight * 0.58;
    const scale = Math.min(maxWidth / prodWidth, maxHeight / prodHeight, 1);
    const newWidth = Math.max(1, Math.round(prodWidth * scale));
    const newHeight = Math.max(1, Math.round(prodHeight * scale));
    product.resize({ w: newWidth, h: newHeight });

    const surfaceY = Math.round(bgHeight * 0.78);
    const x = Math.round((bgWidth - newWidth) / 2);
    const y = Math.max(Math.round(bgHeight * 0.1), surfaceY - newHeight);

    const shadow = createContactShadow(
      Math.max(20, Math.round(newWidth * 0.72)),
      Math.max(8, Math.round(newHeight * 0.055))
    );
    const shadowX = Math.round(x + (newWidth - shadow.bitmap.width) / 2);
    const shadowY = Math.round(surfaceY - shadow.bitmap.height / 2);

    background.composite(shadow, shadowX, shadowY);
    background.composite(product, x, y, {
      opacitySource: 1,
      opacityDest: 1,
    });

    console.log(
      `Product placed naturally: cutout=${prodWidth}x${prodHeight}, resized=${newWidth}x${newHeight}, x=${x}, y=${y}, surfaceY=${surfaceY}`
    );
    console.log(`Image compositing completed in ${Date.now() - startTime}ms`);
    return background.getBuffer('image/jpeg');
  } catch (error: any) {
    console.error('Image compositing failed:', error.message);
    throw error;
  }
}

function cleanSmallAlphaComponents(image: any) {
  const { width, height, data } = image.bitmap;
  const visited = new Uint8Array(width * height);
  const components: number[][] = [];
  const indexOf = (x: number, y: number) => y * width + x;
  const alphaAt = (index: number) => data[index * 4 + 3];

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const start = indexOf(x, y);
      if (visited[start] || alphaAt(start) < ALPHA_THRESHOLD) continue;

      const component: number[] = [];
      const queue = [start];
      visited[start] = 1;

      for (let cursor = 0; cursor < queue.length; cursor++) {
        const current = queue[cursor];
        component.push(current);
        const currentX = current % width;
        const currentY = Math.floor(current / width);
        const neighbors = [
          [currentX - 1, currentY],
          [currentX + 1, currentY],
          [currentX, currentY - 1],
          [currentX, currentY + 1],
        ];

        for (const [neighborX, neighborY] of neighbors) {
          if (neighborX < 0 || neighborY < 0 || neighborX >= width || neighborY >= height) continue;
          const neighbor = indexOf(neighborX, neighborY);
          if (visited[neighbor] || alphaAt(neighbor) < ALPHA_THRESHOLD) continue;
          visited[neighbor] = 1;
          queue.push(neighbor);
        }
      }
      components.push(component);
    }
  }

  const largestSize = Math.max(0, ...components.map((component) => component.length));
  const minimumSize = Math.max(24, Math.round(largestSize * MIN_COMPONENT_RATIO));
  for (const component of components) {
    if (component.length >= minimumSize) continue;
    for (const pixel of component) data[pixel * 4 + 3] = 0;
  }
}

function findAlphaBounds(image: any) {
  const { width, height, data } = image.bitmap;
  let minX = width;
  let minY = height;
  let maxX = -1;
  let maxY = -1;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      if (data[(y * width + x) * 4 + 3] < ALPHA_THRESHOLD) continue;
      minX = Math.min(minX, x);
      minY = Math.min(minY, y);
      maxX = Math.max(maxX, x);
      maxY = Math.max(maxY, y);
    }
  }

  if (maxX < minX || maxY < minY) return null;
  const padding = 4;
  const x = Math.max(0, minX - padding);
  const y = Math.max(0, minY - padding);
  return {
    x,
    y,
    w: Math.min(width - x, maxX - minX + 1 + padding * 2),
    h: Math.min(height - y, maxY - minY + 1 + padding * 2),
  };
}

function createContactShadow(width: number, height: number) {
  const shadow = new Jimp({ width, height, color: 0x00000000 });
  const centerX = (width - 1) / 2;
  const centerY = (height - 1) / 2;

  shadow.scan(0, 0, width, height, function (this: any, x, y, index) {
    const dx = (x - centerX) / Math.max(1, centerX);
    const dy = (y - centerY) / Math.max(1, centerY);
    const distance = dx * dx + dy * dy;
    if (distance >= 1) return;
    this.bitmap.data[index] = 18;
    this.bitmap.data[index + 1] = 18;
    this.bitmap.data[index + 2] = 18;
    this.bitmap.data[index + 3] = Math.round(62 * Math.pow(1 - distance, 1.8));
  });

  return shadow;
}

function retouchProduct(image: any) {
  const { width, height, data } = image.bitmap;
  let redTotal = 0;
  let greenTotal = 0;
  let blueTotal = 0;
  let brightnessTotal = 0;
  let pixelCount = 0;

  for (let index = 0; index < data.length; index += 4) {
    if (data[index + 3] < ALPHA_THRESHOLD) continue;
    const red = data[index];
    const green = data[index + 1];
    const blue = data[index + 2];
    redTotal += red;
    greenTotal += green;
    blueTotal += blue;
    brightnessTotal += red * 0.2126 + green * 0.7152 + blue * 0.0722;
    pixelCount++;
  }

  if (!pixelCount) return;
  const averageRed = redTotal / pixelCount;
  const averageGreen = greenTotal / pixelCount;
  const averageBlue = blueTotal / pixelCount;
  const averageBrightness = brightnessTotal / pixelCount;
  const neutral = (averageRed + averageGreen + averageBlue) / 3;
  const redGain = clamp(neutral / Math.max(1, averageRed), 0.92, 1.08);
  const greenGain = clamp(neutral / Math.max(1, averageGreen), 0.92, 1.08);
  const blueGain = clamp(neutral / Math.max(1, averageBlue), 0.92, 1.08);
  const exposureGain = clamp(122 / Math.max(45, averageBrightness), 0.9, 1.18);

  for (let index = 0; index < data.length; index += 4) {
    if (data[index + 3] < ALPHA_THRESHOLD) continue;
    data[index] = tuneChannel(data[index], redGain * exposureGain);
    data[index + 1] = tuneChannel(data[index + 1], greenGain * exposureGain);
    data[index + 2] = tuneChannel(data[index + 2], blueGain * exposureGain);
  }

  image.contrast(0.06);
  image.convolute([
    [0, -0.18, 0],
    [-0.18, 1.72, -0.18],
    [0, -0.18, 0],
  ]);
  console.log(`Applied local product retouch: ${width}x${height}, exposure=${exposureGain.toFixed(2)}`);
}

function tuneChannel(value: number, gain: number) {
  const corrected = Math.pow(value / 255, 0.94) * 255 * gain;
  return Math.round(clamp(corrected, 0, 255));
}

function clamp(value: number, minimum: number, maximum: number) {
  return Math.min(maximum, Math.max(minimum, value));
}
