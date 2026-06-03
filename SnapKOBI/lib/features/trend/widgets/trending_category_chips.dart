// Trend kategori filtre çipleri.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class TrendingCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const TrendingCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSel = cat == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacing8),
            child: ChoiceChip(
              label: Text(cat), selected: isSel, onSelected: (_) => onSelected(cat),
              selectedColor: AppColors.primary, backgroundColor: theme.colorScheme.surface,
              labelStyle: TextStyle(
                color: isSel ? AppColors.white : theme.hintColor, fontSize: 13,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                side: BorderSide(color: isSel ? AppColors.primary : theme.dividerColor, width: 1),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
