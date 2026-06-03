import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/di/providers.dart';
import 'models/discover_models.dart';

/// `trends`, `admin_templates`, `community_posts` tablolarini anon key ile
/// dogrudan okur. RLS yalnizca is_active=true satirlara public read verir.
class DiscoverDatasource {
  final SupabaseClient _client;
  const DiscoverDatasource(this._client);

  Future<List<TrendItem>> getTrends() async {
    final rows = await _client
        .from('trends')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (rows as List).map((r) {
      final m = r as Map<String, dynamic>;
      return TrendItem(
        title: m['title'] as String? ?? '',
        imageUrl: m['image_url'] as String? ?? '',
        beforeUrl: m['before_url'] as String? ?? '',
        usageCount: (m['usage_count'] as num?)?.toInt() ?? 0,
        category: m['category'] as String? ?? '',
        popularity: '%${(m['popularity'] as num?)?.toInt() ?? 0}',
        sector: m['sector'] as String? ?? 'other',
        platform: _platformLabel(m['platform'] as String?),
        caption: m['caption'] as String? ?? '',
        hashtags: List<String>.from(m['hashtags'] as List? ?? const []),
        scenes: List<String>.from(m['scenes'] as List? ?? const []),
      );
    }).toList();
  }

  Future<List<TemplateItem>> getTemplates() async {
    final rows = await _client
        .from('admin_templates')
        .select()
        .eq('is_active', true)
        .order('is_featured', ascending: false)
        .order('sort_order', ascending: true);

    return (rows as List).map((r) {
      final m = r as Map<String, dynamic>;
      return TemplateItem(
        id: m['id'] as String,
        title: m['name'] as String? ?? '',
        imageUrl: m['thumbnail_url'] as String? ?? '',
        category: m['category'] as String? ?? '',
        usageCount: (m['usage_count'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  Future<List<CommunityItem>> getCommunityPosts() async {
    final rows = await _client
        .from('community_posts')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (rows as List).map((r) {
      final m = r as Map<String, dynamic>;
      return CommunityItem(
        userName: m['user_name'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        beforeUrl: m['before_url'] as String?,
        afterUrl: m['after_url'] as String?,
        platform: _platformLabel(m['platform'] as String?),
        category: m['category'] as String?,
        likesCount: (m['likes_count'] as num?)?.toInt() ?? 0,
        commentsCount: (m['comments_count'] as num?)?.toInt() ?? 0,
        timeAgo: _timeAgo(m['created_at'] as String?),
      );
    }).toList();
  }

  Future<List<BackgroundThemeOption>> getBackgroundThemes() async {
    final rows = await _client
        .from('background_themes')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return (rows as List).map((r) {
      final m = r as Map<String, dynamic>;
      return BackgroundThemeOption(
        id: m['id'] as String,
        label: m['label'] as String? ?? '',
        imageUrl: m['image_url'] as String? ?? '',
      );
    }).toList();
  }

  String _platformLabel(String? raw) {
    switch (raw) {
      case 'instagram':
        return 'Instagram';
      case 'trendyol':
        return 'Trendyol';
      case 'hepsiburada':
        return 'Hepsiburada';
      case 'whatsapp':
        return 'WhatsApp';
      case 'web':
        return 'Web';
      case 'tiktok':
        return 'TikTok';
      default:
        return raw ?? '';
    }
  }

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return '${diff.inDays} gün önce';
  }
}

final discoverDatasourceProvider = Provider<DiscoverDatasource>(
  (ref) => DiscoverDatasource(ref.watch(supabaseClientProvider)),
);
