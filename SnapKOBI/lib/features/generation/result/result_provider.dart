import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultState {
  final String originalImageUrl;
  final String processedImageUrl;
  final String? videoUrl;
  final String videoDuration;
  final String caption;
  final List<String> hashtags;
  final String platformLabel;
  final int processingDurationSec;
  final int qualityScore;

  const ResultState({
    required this.originalImageUrl,
    required this.processedImageUrl,
    this.videoUrl,
    this.videoDuration = '0:05',
    required this.caption,
    required this.hashtags,
    required this.platformLabel,
    required this.processingDurationSec,
    this.qualityScore = 5,
  });

  factory ResultState.mock() => const ResultState(
        originalImageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
        processedImageUrl:
            'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
        caption:
            'Yeni sezon spor ayakkabılarımız stoklarda! 👟✨ Hem şık hem konforlu '
            'tasarımıyla günlük kullanıma mükemmel uyum sağlıyor. Sınırlı stok '
            '— hemen DM at!',
        hashtags: ['#spor', '#ayakkabı', '#yenisezon', '#moda'],
        platformLabel: 'Instagram',
        processingDurationSec: 52,
        qualityScore: 5,
      );
}

class ResultNotifier extends Notifier<ResultState> {
  @override
  ResultState build() => ResultState.mock();

  void updateCaption(String caption) =>
      state = ResultState(
        originalImageUrl: state.originalImageUrl,
        processedImageUrl: state.processedImageUrl,
        videoUrl: state.videoUrl,
        videoDuration: state.videoDuration,
        caption: caption,
        hashtags: state.hashtags,
        platformLabel: state.platformLabel,
        processingDurationSec: state.processingDurationSec,
        qualityScore: state.qualityScore,
      );

  void setResult({
    required String originalImageUrl,
    required String processedImageUrl,
    String? videoUrl,
    required String caption,
    required List<String> hashtags,
    required String platformLabel,
    required int processingDurationSec,
  }) {
    state = ResultState(
      originalImageUrl: originalImageUrl,
      processedImageUrl: processedImageUrl,
      videoUrl: videoUrl,
      caption: caption,
      hashtags: hashtags,
      platformLabel: platformLabel,
      processingDurationSec: processingDurationSec,
      qualityScore: 5,
    );
  }
}

final resultProvider = NotifierProvider<ResultNotifier, ResultState>(
  ResultNotifier.new,
);
