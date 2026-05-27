"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadToSupabaseStorage = uploadToSupabaseStorage;
exports.getSignedUrlForPath = getSignedUrlForPath;
const supabase_1 = require("../../config/supabase");
let bucketsInitialized = false;
async function ensureBucketsExist() {
    if (bucketsInitialized)
        return;
    try {
        const { data: buckets } = await supabase_1.supabase.storage.listBuckets();
        const requiredBuckets = ['uploads', 'results'];
        for (const bName of requiredBuckets) {
            const exists = buckets?.some((b) => b.name === bName);
            if (!exists) {
                console.log(`📦 Creating private "${bName}" storage bucket...`);
                await supabase_1.supabase.storage.createBucket(bName, {
                    public: false, // Private bucket as per architecture guidelines
                });
            }
        }
        bucketsInitialized = true;
    }
    catch (error) {
        console.warn('⚠️ Bucket check/creation failed (might exist already):', error.message);
    }
}
async function uploadToSupabaseStorage(buffer, fileName, bucketName = 'results', contentType = 'image/webp') {
    try {
        await ensureBucketsExist();
        const { data, error } = await supabase_1.supabase.storage
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
        const { data: signData, error: signError } = await supabase_1.supabase.storage
            .from(bucketName)
            .createSignedUrl(fileName, 86400);
        if (signError || !signData?.signedUrl) {
            console.warn(`⚠️ Failed to generate signed URL for ${fileName} in ${bucketName}:`, signError?.message);
            return null;
        }
        return signData.signedUrl;
    }
    catch (error) {
        console.warn('⚠️ Supabase storage helper error:', error.message);
        return null;
    }
}
async function getSignedUrlForPath(bucketName, filePath, expiresInSec = 86400) {
    try {
        const { data, error } = await supabase_1.supabase.storage
            .from(bucketName)
            .createSignedUrl(filePath, expiresInSec);
        if (error || !data?.signedUrl) {
            console.warn(`⚠️ Failed to get signed URL for ${filePath} in ${bucketName}:`, error?.message);
            return null;
        }
        return data.signedUrl;
    }
    catch (error) {
        console.warn('⚠️ Failed to generate signed URL:', error.message);
        return null;
    }
}
