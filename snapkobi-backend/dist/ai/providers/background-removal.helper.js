"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.removeProductBackground = removeProductBackground;
const background_removal_node_1 = require("@imgly/background-removal-node");
/**
 * Removes the background of an image locally using @imgly/background-removal-node.
 * Returns a Buffer containing the transparent PNG product cutout.
 */
async function removeProductBackground(imageBuffer, contentType) {
    console.log('🤖 Performing local background removal using @imgly/background-removal-node...');
    try {
        const startTime = Date.now();
        const mimeType = resolveImageMimeType(imageBuffer, contentType);
        const imageBlob = new Blob([imageBuffer], { type: mimeType });
        const blob = await (0, background_removal_node_1.removeBackground)(imageBlob, {
            debug: false,
        });
        const buffer = Buffer.from(await blob.arrayBuffer());
        console.log(`✅ Local background removal successful in ${Date.now() - startTime}ms`);
        return buffer;
    }
    catch (error) {
        console.error('❌ Local background removal failed:', error.message);
        throw error;
    }
}
function resolveImageMimeType(imageBuffer, contentType) {
    const normalized = contentType?.split(';', 1)[0].trim().toLowerCase();
    if (normalized?.startsWith('image/')) {
        return normalized;
    }
    if (imageBuffer.subarray(0, 3).equals(Buffer.from([0xff, 0xd8, 0xff]))) {
        return 'image/jpeg';
    }
    if (imageBuffer.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
        return 'image/png';
    }
    if (imageBuffer.subarray(0, 4).toString('ascii') === 'RIFF' &&
        imageBuffer.subarray(8, 12).toString('ascii') === 'WEBP') {
        return 'image/webp';
    }
    throw new Error('Unsupported image format. Upload a JPG, PNG, or WebP image.');
}
