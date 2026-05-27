import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../history_provider.dart';

class HistoryFilterChips extends ConsumerWidget {
  const HistoryFilterChips({super.key});

  static const _labels = {
    HistoryFilter.all: 'Tümü',
    HistoryFilter.thisWeek: 'Bu Hafta',
    HistoryFilter.images: 'Görseller',
    HistoryFilter.videos: 'Videolar',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(historyProvider).filter;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      child: Row(
        children: _labels.entries.map((e) {
          final isSelected = active == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacing8),
            child: ChoiceChip(
              label: Text(e.value),
              selected: isSelected,
              onSelected: (_) => ref.read(historyProvider.notifier).setFilter(e.key),
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: isSelected ? theme.colorScheme.onPrimary : primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: theme.cardTheme.color ?? theme.cardColor,
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                side: BorderSide(color: isSelected ? Colors.transparent : primaryColor),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
