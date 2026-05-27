import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../discover/discover_provider.dart';
import 'widgets/trending_bottom_bar.dart';
import 'widgets/trending_category_chips.dart';
import 'widgets/trending_grid_card.dart';
import 'widgets/trending_search_field.dart';

class TrendingScreen extends ConsumerStatefulWidget {
  const TrendingScreen({super.key});

  @override
  ConsumerState<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends ConsumerState<TrendingScreen> {
  String _searchQuery = '';
  String _selectedCat = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(discoverProvider);
    final cats = ['Tümü', ...state.trends.map((e) => e.category).toSet()];
    final filtered = state.trends.where((e) {
      final matchesSearch = e.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCat == 'Tümü' || e.category == _selectedCat;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, elevation: 0,
        leading: IconButton(icon: const Icon(AppIcons.back, color: AppColors.primaryDark), onPressed: () => context.pop()),
        title: Text('Bu Hafta Trend', style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(AppIcons.notification, color: AppColors.primaryDark), onPressed: () {})],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TrendingSearchField(onChanged: (val) => setState(() => _searchQuery = val)),
        TrendingCategoryChips(categories: cats, selectedCategory: _selectedCat, onSelected: (val) => setState(() => _selectedCat = val)),
        Expanded(child: filtered.isEmpty ? Center(child: Text('Aradığınız kriterde trend bulunamadı.', style: TextStyle(color: theme.hintColor))) : GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: AppDimensions.spacing16, mainAxisSpacing: AppDimensions.spacing16, childAspectRatio: 0.58),
          itemCount: filtered.length,
          itemBuilder: (context, i) => TrendingGridCard(item: filtered[i]),
        )),
      ]),
      bottomNavigationBar: const TrendingBottomBar(),
    );
  }
}
