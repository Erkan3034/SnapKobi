import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract final class FileHelper {
  /// Downloads a network image and saves it securely to the mobile photo gallery.
  static Future<void> saveNetworkImageToGallery(String url) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/snapkobi_img_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final dio = Dio();
    await dio.download(url, filePath);

    // Save to device photo gallery
    await Gal.putImage(filePath);

    // Clean up local temp file
    try {
      await File(filePath).delete();
    } catch (_) {}
  }

  /// Downloads a network video and saves it securely to the mobile photo gallery.
  static Future<void> saveNetworkVideoToGallery(String url) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/snapkobi_vid_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final dio = Dio();
    await dio.download(url, filePath);

    // Save to device video gallery
    await Gal.putVideo(filePath);

    // Clean up local temp file
    try {
      await File(filePath).delete();
    } catch (_) {}
  }

  /// Downloads the generated media and shares it natively along with caption and hashtags.
  static Future<void> shareAll({
    required String imageUrl,
    required String caption,
    required List<String> hashtags,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/snapkobi_share_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final dio = Dio();
    await dio.download(imageUrl, filePath);

    final fullText = '$caption\n\n${hashtags.join(' ')}';
    
    // Trigger OS native sharing sheet
    await Share.shareXFiles(
      [XFile(filePath)],
      text: fullText,
    );

    // Clean up temp file
    try {
      await File(filePath).delete();
    } catch (_) {}
  }
}
