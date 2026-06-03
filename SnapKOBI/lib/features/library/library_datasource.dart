import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/di/providers.dart';
import 'library_provider.dart';

class LibraryDatasource {
  final SupabaseClient _client;
  const LibraryDatasource(this._client);

  Future<List<LibraryTemplate>> getTemplates() async {
    final rows = await _client
        .from('admin_templates')
        .select()
        .eq('is_active', true)
        .order('is_featured', ascending: false)
        .order('sort_order', ascending: true);

    return (rows as List).map((r) {
      final m = r as Map<String, dynamic>;
      return LibraryTemplate(
        id: m['id'] as String,
        title: m['name'] as String? ?? '',
        imageUrl: m['thumbnail_url'] as String? ?? '',
        category: m['category'] as String? ?? 'other',
        usageCount: (m['usage_count'] as num?)?.toInt() ?? 0,
        isPremium: m['is_premium'] as bool? ?? false,
      );
    }).toList();
  }
}

final libraryDatasourceProvider = Provider<LibraryDatasource>(
  (ref) => LibraryDatasource(ref.watch(supabaseClientProvider)),
);
