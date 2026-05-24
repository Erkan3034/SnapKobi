import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendItem {
  final String title;
  final String imageUrl;
  final int usageCount;
  final String category;
  const TrendItem({required this.title, required this.imageUrl, required this.usageCount, required this.category});
}

class TemplateItem {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final int usageCount;
  const TemplateItem({required this.id, required this.title, required this.imageUrl, required this.category, required this.usageCount});
}

class CommunityItem {
  final String userName;
  final String beforeUrl;
  final String afterUrl;
  final String timeAgo;
  final String platform;
  const CommunityItem({required this.userName, required this.beforeUrl, required this.afterUrl, required this.timeAgo, required this.platform});
}

class DiscoverState {
  final List<TrendItem> trends;
  final List<TemplateItem> templates;
  final List<CommunityItem> community;
  const DiscoverState({this.trends = const [], this.templates = const [], this.community = const []});
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(_mockData);

  static const _mockData = DiscoverState(
    trends: [
      TrendItem(title: 'Spor Ayakkabı', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80', usageCount: 1247, category: 'Tekstil'),
      TrendItem(title: 'Akıllı Saat', imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80', usageCount: 856, category: 'Elektronik'),
      TrendItem(title: 'El Çantası', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&q=80', usageCount: 634, category: 'Aksesuar'),
      TrendItem(title: 'Parfüm', imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400&q=80', usageCount: 512, category: 'Kozmetik'),
    ],
    templates: [
      TemplateItem(id: '1', title: 'Studio Beyaz', imageUrl: 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=300&q=80', category: 'Stüdyo', usageCount: 2340),
      TemplateItem(id: '2', title: 'Doğa Yeşili', imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=300&q=80', category: 'Doğa', usageCount: 1120),
      TemplateItem(id: '3', title: 'Minimalist', imageUrl: 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=300&q=80', category: 'Minimal', usageCount: 980),
      TemplateItem(id: '4', title: 'Neon Gece', imageUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=300&q=80', category: 'Neon', usageCount: 870),
      TemplateItem(id: '5', title: 'Lüks Mermer', imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=300&q=80', category: 'Lüks', usageCount: 760),
      TemplateItem(id: '6', title: 'Gradient', imageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=300&q=80', category: 'Gradient', usageCount: 650),
    ],
    community: [
      CommunityItem(userName: 'ayakkabi_dunyasi', beforeUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80', afterUrl: 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80', timeAgo: '2 saat önce', platform: 'Instagram'),
      CommunityItem(userName: 'tech_store_tr', beforeUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80', afterUrl: 'https://images.unsplash.com/photo-1546868871-af0de0ae72be?w=400&q=80', timeAgo: '5 saat önce', platform: 'Trendyol'),
    ],
  );
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>(
  (ref) => DiscoverNotifier(),
);
