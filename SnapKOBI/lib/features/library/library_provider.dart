import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class LibraryState {
  final String selectedCategory;
  final List<LibraryCategory> categories;
  final List<LibraryTemplate> templates;
  const LibraryState({this.selectedCategory = 'all', this.categories = const [], this.templates = const []});
  LibraryState copyWith({String? selectedCategory}) =>
      LibraryState(selectedCategory: selectedCategory ?? this.selectedCategory, categories: categories, templates: templates);
}

class LibraryNotifier extends StateNotifier<LibraryState> {
  LibraryNotifier() : super(_mockData);
  void setCategory(String cat) => state = state.copyWith(selectedCategory: cat);

  static const _mockData = LibraryState(
    categories: [
      LibraryCategory(id: 'all', title: 'Tümü', emoji: '🗂️', templateCount: 24),
      LibraryCategory(id: 'product', title: 'Ürün', emoji: '📦', templateCount: 8),
      LibraryCategory(id: 'food', title: 'Gıda', emoji: '🍕', templateCount: 6),
      LibraryCategory(id: 'fashion', title: 'Moda', emoji: '👗', templateCount: 5),
      LibraryCategory(id: 'tech', title: 'Teknoloji', emoji: '💻', templateCount: 5),
    ],
    templates: [
      LibraryTemplate(id: '1', title: 'Studio Beyaz', imageUrl: 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=300&q=80', category: 'product', usageCount: 2340),
      LibraryTemplate(id: '2', title: 'Neon Gece', imageUrl: 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=300&q=80', category: 'tech', usageCount: 870, isPremium: true),
      LibraryTemplate(id: '3', title: 'Doğa Yeşili', imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=300&q=80', category: 'product', usageCount: 1120),
      LibraryTemplate(id: '4', title: 'Lüks Mermer', imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=300&q=80', category: 'fashion', usageCount: 760, isPremium: true),
      LibraryTemplate(id: '5', title: 'Yemek Masası', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&q=80', category: 'food', usageCount: 540),
      LibraryTemplate(id: '6', title: 'Gradient', imageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=300&q=80', category: 'tech', usageCount: 650),
    ],
  );
}

final libraryProvider = StateNotifierProvider<LibraryNotifier, LibraryState>((ref) => LibraryNotifier());
