import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageDatasource {
  final SupabaseClient _client;

  const SupabaseStorageDatasource(this._client);

  Future<String> uploadOriginalImage(String localPath) async {
    final file = File(localPath);
    final userId = _client.auth.currentUser?.id ?? 'guest';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = file.uri.pathSegments.last;
    final fileName = '$userId/${timestamp}_$baseName';

    // Upload to the private 'uploads' bucket as per architectural rules
    await _client.storage.from('uploads').upload(
      fileName,
      file,
      fileOptions: const FileOptions(
        contentType: 'image/jpeg',
        upsert: true,
      ),
    );

    // Return the relative path so backend can access it securely via its service_role bypass
    return fileName;
  }

  Future<String> getSignedUrl(String bucket, String path) async {
    try {
      final signedUrl = await _client.storage.from(bucket).createSignedUrl(path, 86400);
      return signedUrl;
    } catch (e) {
      return _client.storage.from(bucket).getPublicUrl(path);
    }
  }
}
