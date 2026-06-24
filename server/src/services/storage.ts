import getSupabase from '../config/supabase';
import { v4 as uuid } from 'uuid';

const sb = getSupabase();

export async function uploadFile(
  bucket: string,
  file: Express.Multer.File,
  userId: string
): Promise<{ url: string; path: string }> {
  const ext = file.originalname.split('.').pop() || 'bin';
  const path = `${userId}/${uuid()}.${ext}`;

  const { data, error } = await sb.storage
    .from(bucket)
    .upload(path, file.buffer, {
      contentType: file.mimetype,
      upsert: false,
    });

  if (error) throw new Error(`Storage upload failed: ${error.message}`);

  const { data: urlData } = sb.storage.from(bucket).getPublicUrl(data.path);

  return { url: urlData.publicUrl, path: data.path };
}

export async function deleteFile(bucket: string, path: string): Promise<void> {
  const { error } = await sb.storage.from(bucket).remove([path]);
  if (error) throw new Error(`Storage delete failed: ${error.message}`);
}

export async function listFiles(bucket: string, prefix: string) {
  const { data, error } = await sb.storage.from(bucket).list(prefix);
  if (error) throw new Error(`Storage list failed: ${error.message}`);
  return data;
}

export async function uploadToStorage(params: {
  bucket: string;
  fileName: string;
  fileBuffer: Buffer;
  contentType: string;
}): Promise<{ url: string; publicUrl: string; path: string }> {
  const { bucket, fileName, fileBuffer, contentType } = params;
  const { data, error } = await sb.storage
    .from(bucket)
    .upload(fileName, fileBuffer, { contentType, upsert: true });

  if (error) throw new Error(`Storage upload failed: ${error.message}`);

  const { data: urlData } = sb.storage.from(bucket).getPublicUrl(data.path);
  return { url: urlData.publicUrl, publicUrl: urlData.publicUrl, path: data.path };
}

export async function ensureBucket(bucket: string): Promise<void> {
  const { data: buckets } = await sb.storage.listBuckets();
  const exists = buckets?.some((b) => b.name === bucket);
  if (!exists) {
    await sb.storage.createBucket(bucket, {
      public: true,
      allowedMimeTypes: [
        'image/*',
        'application/pdf',
        'video/mp4',
        'video/webm',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'audio/mpeg',
        'audio/mp3',
        'application/json',
      ],
    });
  }
}
