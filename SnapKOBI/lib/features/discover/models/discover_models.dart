class TrendItem {
  final String title;
  final String imageUrl;
  final String beforeUrl;
  final int usageCount;
  final String category;
  final String popularity;
  final String sector;
  final String platform;
  final String caption;
  final List<String> hashtags;
  final List<String> scenes;

  const TrendItem({
    required this.title,
    required this.imageUrl,
    required this.beforeUrl,
    required this.usageCount,
    required this.category,
    required this.popularity,
    required this.sector,
    required this.platform,
    required this.caption,
    required this.hashtags,
    required this.scenes,
  });
}

class TemplateItem {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final int usageCount;
  const TemplateItem({required this.id, required this.title, required this.imageUrl, required this.category, required this.usageCount});
}

/// Create ekranindaki arka plan temasi secenegi (background_themes tablosu).
/// `id` pipeline'in bekledigi stil anahtaridir (studio, nature, luxury...).
class BackgroundThemeOption {
  final String id;
  final String label;
  final String imageUrl;
  const BackgroundThemeOption({required this.id, required this.label, required this.imageUrl});
}

class CommunityItem {
  final String? userName;
  final String? beforeUrl;
  final String? afterUrl;
  final String? timeAgo;
  final String? platform;
  final String? category;
  final int? likesCount;
  final int? commentsCount;
  final String? avatarUrl;

  const CommunityItem({
    this.userName,
    this.beforeUrl,
    this.afterUrl,
    this.timeAgo,
    this.platform,
    this.category,
    this.likesCount,
    this.commentsCount,
    this.avatarUrl,
  });
}
