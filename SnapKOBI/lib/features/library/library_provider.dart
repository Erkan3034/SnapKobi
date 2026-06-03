// Kütüphane state'i + kategori/sıralama/arama — LibraryNotifier, LibraryTemplate modeli.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import 'library_datasource.dart';

class LibraryCategory {
  final String id;
  final String title;
  final String emoji;
  final int templateCount;
  const LibraryCategory({required this.id, required this.title, required this.emoji, required this.templateCount});
}

class LibraryTemplate {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  final int usageCount;
  final bool isPremium;
  const LibraryTemplate({required this.id, required this.title, required this.imageUrl, required this.category, required this.usageCount, this.isPremium = false});
}

/// Kütüphane gelişmiş filtre/sıralama seçenekleri (alt sayfadan tetiklenir).
enum LibrarySort { none, popular }

class LibraryState {
  final String selectedCategory;
  final List<LibraryCategory> categories;
  final List<LibraryTemplate> templates;
  final bool isLoading;
  final LibrarySort sort;
  final bool premiumOnly;
  const LibraryState({
    this.selectedCategory = 'all',
    this.categories = const [],
    this.templates = const [],
    this.isLoading = true,
    this.sort = LibrarySort.none,
    this.premiumOnly = false,
  });
  LibraryState copyWith({
    String? selectedCategory,
    List<LibraryCategory>? categories,
    List<LibraryTemplate>? templates,
    bool? isLoading,
    LibrarySort? sort,
    bool? premiumOnly,
  }) =>
      LibraryState(
        selectedCategory: selectedCategory ?? this.selectedCategory,
        categories: categories ?? this.categories,
        templates: templates ?? this.templates,
        isLoading: isLoading ?? this.isLoading,
        sort: sort ?? this.sort,
        premiumOnly: premiumOnly ?? this.premiumOnly,
      );

  /// Kategori + premium + sıralama uygulanmış liste (arama ekranda eklenir).
  List<LibraryTemplate> get filtered {
    var list = selectedCategory == 'all'
        ? templates
        : templates.where((t) => t.category == selectedCategory).toList();
    if (premiumOnly) {
      list = list.where((t) => t.isPremium).toList();
    }
    if (sort == LibrarySort.popular) {
      list = [...list]..sort((a, b) => b.usageCount.compareTo(a.usageCount));
    }
    return list;
  }
}

// category id -> (emoji, Türkçe başlık). admin_templates.category degerleriyle eslesir.
const _categoryMeta = <String, ({String emoji, String title})>{
  'product': (emoji: '📦', title: 'Ürün'),
  'food': (emoji: '🍕', title: 'Gıda'),
  'fashion': (emoji: '👗', title: 'Moda'),
  'tech': (emoji: '💻', title: 'Teknoloji'),
  'beauty': (emoji: '🌿', title: 'Kozmetik'),
  'other': (emoji: '🗂️', title: 'Diğer'),
};

class LibraryNotifier extends StateNotifier<LibraryState> {
  final Ref _ref;

  LibraryNotifier(this._ref) : super(const LibraryState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    try {
      final templates = await _ref.read(libraryDatasourceProvider).getTemplates();
      if (!mounted) return;
      state = state.copyWith(
        templates: templates,
        categories: _buildCategories(templates),
        isLoading: false,
      );
    } catch (e, st) {
      AppLogger.e('Kütüphane şablonları yüklenemedi', e, st);
      if (!mounted) return;
      state = state.copyWith(templates: const [], categories: const [], isLoading: false);
    }
  }

  List<LibraryCategory> _buildCategories(List<LibraryTemplate> templates) {
    final counts = <String, int>{};
    for (final t in templates) {
      counts[t.category] = (counts[t.category] ?? 0) + 1;
    }
    final cats = <LibraryCategory>[
      LibraryCategory(id: 'all', title: 'Tümü', emoji: '🗂️', templateCount: templates.length),
    ];
    for (final entry in counts.entries) {
      final meta = _categoryMeta[entry.key] ?? (emoji: '🏷️', title: entry.key);
      cats.add(LibraryCategory(id: entry.key, title: meta.title, emoji: meta.emoji, templateCount: entry.value));
    }
    return cats;
  }

  void setCategory(String cat) => state = state.copyWith(selectedCategory: cat);

  void setSort(LibrarySort sort) => state = state.copyWith(sort: sort);

  void setPremiumOnly(bool value) => state = state.copyWith(premiumOnly: value);

  void clearFilters() => state = state.copyWith(sort: LibrarySort.none, premiumOnly: false);
}

final libraryProvider = StateNotifierProvider<LibraryNotifier, LibraryState>((ref) => LibraryNotifier(ref));

/// Kütüphane arama sorgusu (şablon adına göre filtreler).
final librarySearchProvider = StateProvider<String>((ref) => '');
