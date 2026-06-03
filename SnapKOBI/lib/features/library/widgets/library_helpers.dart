// Kütüphane filtre bottom sheet'i ve yardımcı fonksiyonlar.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../library_provider.dart';

void showLibraryFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
    ),
    builder: (_) => const _LibraryFilterSheet(),
  );
}

class _LibraryFilterSheet extends ConsumerWidget {
  const _LibraryFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(libraryProvider);
    final notifier = ref.read(libraryProvider.notifier);
    final popular = state.sort == LibrarySort.popular;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Kütüphane Filtreleme', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing8),
          SwitchListTile(
            secondary: const Icon(Icons.star, color: AppColors.warning),
            title: Text('Yalnızca Öncelikli (PRO) Şablonlar', style: theme.textTheme.bodyMedium),
            value: state.premiumOnly,
            activeColor: theme.colorScheme.primary,
            onChanged: (v) => notifier.setPremiumOnly(v),
          ),
          SwitchListTile(
            secondary: Icon(Icons.trending_up, color: theme.colorScheme.primary),
            title: Text('En Popülere Göre Sırala', style: theme.textTheme.bodyMedium),
            value: popular,
            activeColor: theme.colorScheme.primary,
            onChanged: (v) => notifier.setSort(v ? LibrarySort.popular : LibrarySort.none),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  notifier.clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Temizle'),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Uygula'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
