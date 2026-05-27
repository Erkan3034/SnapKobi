import 'package:equatable/equatable.dart';
import 'sector.dart';
import 'platform_type.dart';

class Generation extends Equatable {
  final String id;
  final String userId;
  final String originalImageUrl;
  final String? processedImageUrl;
  final String? videoUrl;
  final String? caption;
  final List<String> hashtags;
  final SectorType sector;
  final PlatformType platform;
  final GenerationStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Generation({
    required this.id,
    required this.userId,
    required this.originalImageUrl,
    this.processedImageUrl,
    this.videoUrl,
    this.caption,
    this.hashtags = const [],
    required this.sector,
    required this.platform,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  bool get isCompleted => status == GenerationStatus.completed;
  bool get isFailed => status == GenerationStatus.failed;
  bool get isProcessing => status != GenerationStatus.completed &&
                           status != GenerationStatus.failed;

  Generation copyWith({
    String? id,
    String? userId,
    String? originalImageUrl,
    String? processedImageUrl,
    String? videoUrl,
    String? caption,
    List<String>? hashtags,
    SectorType? sector,
    PlatformType? platform,
    GenerationStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) => Generation(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    originalImageUrl: originalImageUrl ?? this.originalImageUrl,
    processedImageUrl: processedImageUrl ?? this.processedImageUrl,
    videoUrl: videoUrl ?? this.videoUrl,
    caption: caption ?? this.caption,
    hashtags: hashtags ?? this.hashtags,
    sector: sector ?? this.sector,
    platform: platform ?? this.platform,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt ?? this.completedAt,
  );

  @override
  List<Object?> get props => [id, status, processedImageUrl, videoUrl, caption];
}

enum GenerationStatus {
  pending,
  uploadingImage,
  processingImage,
  processingVideo,
  generatingCaption,
  completed,
  failed,
  cancelled
}
