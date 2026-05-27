import '../../domain/entities/generation.dart';
import '../../domain/entities/sector.dart';
import '../../domain/entities/platform_type.dart';

class GenerationModel {
  final String id;
  final String userId;
  final String originalImageUrl;
  final String? processedImageUrl;
  final String? videoUrl;
  final String? caption;
  final List<String> hashtags;
  final String sector;
  final String platform;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const GenerationModel({
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

  factory GenerationModel.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['userId'] ?? json['user_id'];
    final rawOriginalPath = json['originalImagePath'] ?? json['original_image_path'];
    final rawProcessedPath = json['processedImagePath'] ?? json['processed_image_path'];
    final rawVideoPath = json['videoPath'] ?? json['video_path'] ?? json['video_url'];
    final rawCreatedAt = json['createdAt'] ?? json['created_at'];
    final rawCompletedAt = json['completedAt'] ?? json['completed_at'];

    return GenerationModel(
      id: json['id'] as String,
      userId: rawUserId as String,
      originalImageUrl: rawOriginalPath as String,
      processedImageUrl: rawProcessedPath as String?,
      videoUrl: rawVideoPath as String?,
      caption: json['caption'] as String?,
      hashtags: json['hashtags'] != null
          ? (json['hashtags'] is String
              ? _parsePostgresArray(json['hashtags'] as String)
              : List<String>.from(json['hashtags'] as List))
          : const [],
      sector: json['sector'] as String,
      platform: json['platform'] as String,
      status: json['status'] as String,
      createdAt: _parseDateTime(rawCreatedAt),
      completedAt: rawCompletedAt != null ? _parseDateTime(rawCompletedAt) : null,
    );
  }

  static List<String> _parsePostgresArray(String pgArray) {
    if (pgArray.isEmpty || pgArray == '{}') return [];
    if (!pgArray.startsWith('{') || !pgArray.endsWith('}')) return [pgArray];
    final content = pgArray.substring(1, pgArray.length - 1);
    if (content.isEmpty) return [];
    return content.split(',').map((e) => e.trim().replaceAll('"', '')).toList();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value.toLocal();
    if (value is String) return DateTime.parse(value).toLocal();
    throw ArgumentError('Invalid date format: $value');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'original_image_path': originalImageUrl,
      'processed_image_path': processedImageUrl,
      'video_path': videoUrl,
      'caption': caption,
      'hashtags': hashtags,
      'sector': sector,
      'platform': platform,
      'status': status,
      'created_at': createdAt.toUtc().toIso8601String(),
      'completed_at': completedAt?.toUtc().toIso8601String(),
    };
  }

  Generation toEntity() {
    return Generation(
      id: id,
      userId: userId,
      originalImageUrl: originalImageUrl,
      processedImageUrl: processedImageUrl,
      videoUrl: videoUrl,
      caption: caption,
      hashtags: hashtags,
      sector: _parseSector(sector),
      platform: _parsePlatform(platform),
      status: _parseStatus(status),
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  static SectorType _parseSector(String val) {
    return SectorType.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => SectorType.other,
    );
  }

  static PlatformType _parsePlatform(String val) {
    return PlatformType.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => PlatformType.instagram,
    );
  }

  static GenerationStatus _parseStatus(String val) {
    switch (val.toLowerCase()) {
      case 'pending':
        return GenerationStatus.pending;
      case 'uploading_image':
      case 'uploadingimage':
        return GenerationStatus.uploadingImage;
      case 'processing_image':
      case 'processingimage':
        return GenerationStatus.processingImage;
      case 'processing_video':
      case 'processingvideo':
        return GenerationStatus.processingVideo;
      case 'generating_caption':
      case 'generatingcaption':
        return GenerationStatus.generatingCaption;
      case 'completed':
        return GenerationStatus.completed;
      case 'failed':
        return GenerationStatus.failed;
      case 'cancelled':
        return GenerationStatus.cancelled;
      default:
        return GenerationStatus.pending;
    }
  }
}
