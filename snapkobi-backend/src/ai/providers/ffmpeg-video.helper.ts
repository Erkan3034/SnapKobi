import { execFile } from 'child_process';
import { promisify } from 'util';
import { promises as fs } from 'fs';
import os from 'os';
import path from 'path';
import ffmpegStatic from 'ffmpeg-static';
import { uploadToSupabaseStorage } from './storage.helper';

const execFileAsync = promisify(execFile);

// ffmpeg-static, kurulu platforma uygun statik binary yolunu dondurur (Railway Linux dahil).
const ffmpegPath: string | null = ffmpegStatic as unknown as string | null;

/**
 * Islenmis urun gorselinden YEREL olarak 5 saniyelik 9:16 tanitim videosu uretir
 * (yumusak "Ken Burns" zoom efekti). Hicbir dis API/kota gerektirmez; ffmpeg-static
 * binary'si sunucuda calisir. Basarisiz olursa hata firlatir (cagiran taraf yonetir).
 */
export async function generateKenBurnsVideo(
  imageBuffer: Buffer,
  generationId: string
): Promise<string> {
  if (!ffmpegPath) {
    throw new Error('ffmpeg binary (ffmpeg-static) bulunamadi');
  }

  const tmpDir = os.tmpdir();
  const inputPath = path.join(tmpDir, `snapkobi_${generationId}_in.jpg`);
  const outputPath = path.join(tmpDir, `snapkobi_${generationId}_out.mp4`);

  try {
    await fs.writeFile(inputPath, imageBuffer);

    // Tek gorselden 5sn (125 kare @ 25fps) portre video; yavas zoom 1.0 -> 1.18.
    // Once 9:16 tabana kirp, sonra zoompan ile yumusak zoom uygula.
    const vf =
      'scale=1620:2880:force_original_aspect_ratio=increase,' +
      'crop=1620:2880,' +
      "zoompan=z='min(zoom+0.0009,1.18)':d=125:s=1080x1920:fps=25," +
      'format=yuv420p';

    await execFileAsync(
      ffmpegPath,
      [
        '-y',
        '-loglevel', 'error',
        '-i', inputPath,
        '-vf', vf,
        '-c:v', 'libx264',
        '-pix_fmt', 'yuv420p',
        '-movflags', '+faststart',
        outputPath,
      ],
      { maxBuffer: 1024 * 1024 * 16 }
    );

    const videoBuffer = await fs.readFile(outputPath);
    const signedUrl = await uploadToSupabaseStorage(
      videoBuffer,
      `videos/${generationId}.mp4`,
      'results',
      'video/mp4'
    );

    if (!signedUrl) {
      throw new Error('Ken Burns videosu Supabase Storage yuklemesi null dondu');
    }
    return signedUrl;
  } finally {
    await Promise.allSettled([fs.unlink(inputPath), fs.unlink(outputPath)]);
  }
}
