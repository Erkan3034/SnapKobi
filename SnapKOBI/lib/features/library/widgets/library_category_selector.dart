import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../library_provider.dart';

class LibraryCategorySelector extends ConsumerWidget {
  const LibraryCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
        itemCount: state.categories.length,
        itemBuilder: (_, i) {
          final cat = state.categories[i];
          final isActive = state.selectedCategory == cat.id;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacing8),
            child: ChoiceChip(
              label: Text('${cat.emoji} ${cat.title}'),
              selected: isActive,
              onSelected: (_) => ref.read(libraryProvider.notifier).setCategory(cat.id),
              showCheckmark: false,
              selectedColor: primary,
              labelStyle: AppTypography.labelSmall.copyWith(
                color: isActive ? theme.colorScheme.onPrimary : primary,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                side: BorderSide(
                  color: isActive ? Colors.transparent : primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
