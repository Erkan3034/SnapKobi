import { supabase } from '../../config/supabase';

let bucketsInitialized = false;

async function ensureBucketsExist() {
  if (bucketsInitialized) return;
  try {
    const { data: buckets } = await supabase.storage.listBuckets();
    
    const requiredBuckets = ['uploads', 'results'];
    for (const bName of requiredBuckets) {
      const exists = buckets?.some((b) => b.name === bName);
      if (!exists) {
        console.log(`📦 Creating private "${bName}" storage bucket...`);
        await supabase.storage.createBucket(bName, {
          public: false, // Private bucket as per architecture guidelines
        });
      }
    }
    bucketsInitialized = true;
  } catch (error: any) {
    console.warn('⚠️ Bucket check/creation failed (might exist already):', error.message);
  }
}

export async function uploadToSupabaseStorage(
  buffer: Buffer,
  fileName: string,
  bucketName: string = 'results',
  contentType: string = 'image/webp'
): Promise<string | null> {
  try {
    await ensureBucketsExist();

    const { data, error } = await supabase.storage
      .from(bucketName)
      .upload(fileName, buffer, {
        contentType,
        upsert: true,
      });

    if (error) {
      console.warn(`⚠️ Supabase storage upload failed to ${bucketName}:`, error.message);
      return null;
    }

    // Generate a signed URL valid for 24 hours (86400 seconds)
    const { data: signData, error: signError } = await supabase.storage
      .from(bucketName)
      .createSignedUrl(fileName, 86400);

    if (signError || !signData?.signedUrl) {
      console.warn(`⚠️ Failed to generate signed URL for ${fileName} in ${bucketName}:`, signError?.message);
      return null;
    }

    return signData.signedUrl;
  } catch (error: any) {
    console.warn('⚠️ Supabase storage helper error:', error.message);
    return null;
  }
}

export async function getSignedUrlForPath(
  bucketName: string,
  filePath: string,
  expiresInSec: number = 86400
): Promise<string | null> {
  try {
    const { data, error } = await supabase.storage
      .from(bucketName)
      .createSignedUrl(filePath, expiresInSec);

    if (error || !data?.signedUrl) {
      console.warn(`⚠️ Failed to get signed URL for ${filePath} in ${bucketName}:`, error?.message);
      return null;
    }
    return data.signedUrl;
  } catch (error: any) {
    console.warn('⚠️ Failed to generate signed URL:', error.message);
    return null;
  }
}

