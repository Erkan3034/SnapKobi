import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import 'library_provider.dart';
import 'widgets/template_grid_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final filtered = state.selectedCategory == 'all'
        ? state.templates
        : state.templates.where((t) => t.category == state.selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white, surfaceTintColor: AppColors.transparent,
        title: Text('Kütüphane', style: AppTypography.headlineMedium.copyWith(fontSize: 20)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(AppIcons.filter, color: AppColors.textPrimary),
          onPressed: () => _showFilterSheet(context))],
      ),
      body: Column(children: [
        SizedBox(height: 50, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12, vertical: AppDimensions.spacing8),
          itemCount: state.categories.length,
          itemBuilder: (_, i) {
            final cat = state.categories[i];
            final isActive = state.selectedCategory == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing8),
              child: ChoiceChip(label: Text('${cat.emoji} ${cat.title}'), selected: isActive,
                onSelected: (_) => ref.read(libraryProvider.notifier).setCategory(cat.id), showCheckmark: false,
                selectedColor: AppColors.primary,
                labelStyle: AppTypography.labelSmall.copyWith(color: isActive ? AppColors.white : AppColors.primary, fontWeight: FontWeight.w600),
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  side: BorderSide(color: isActive ? AppColors.transparent : AppColors.primary))),
            );
          },
        )),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: AppDimensions.spacing12,
            mainAxisSpacing: AppDimensions.spacing12, childAspectRatio: 0.82),
          itemCount: filtered.length,
          itemBuilder: (_, i) => TemplateGridCard(template: filtered[i]),
        )),
      ]),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Kütüphane Filtreleme', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(leading: const Icon(Icons.star, color: AppColors.warning), title: const Text('Öncelikli Şablonlar (PRO)'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.trending_up, color: AppColors.primary), title: const Text('En Popüler Şablonlar'), onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}
