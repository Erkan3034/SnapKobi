import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import 'dashed_circle_painter.dart';

/// Topluluk vitrini kategori dairesi. Veriden (community_posts) turetilir;
/// gorsel de gercek bir gonderinin sonucundan gelir (sabit/mock degil).
class CommunityCatChip {
  final String key;
  final String label;
  final String? imageUrl;
  final IconData? icon;
  const CommunityCatChip({required this.key, required this.label, this.imageUrl, this.icon});
}

class CommunityCategoryList extends StatelessWidget {
  final List<CommunityCatChip> categories;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  const CommunityCategoryList({
    super.key,
    required this.categories,
    required this.selectedKey,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedKey == cat.key;
          final hasImage = (cat.imageUrl != null && cat.imageUrl!.trim().isNotEmpty);

          return GestureDetector(
            onTap: () => onSelected(cat.key),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryLightest : AppColors.transparent,
                    border: isSelected && hasImage ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: hasImage
                      ? Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          child: AppNetworkImage(url: cat.imageUrl, width: 56, height: 56),
                        )
                      : CustomPaint(
                          painter: DashedCirclePainter(color: isSelected ? AppColors.primary : theme.hintColor),
                          child: Center(child: Icon(cat.icon ?? Icons.star, color: isSelected ? AppColors.primary : theme.hintColor, size: 24)),
                        ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  cat.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? AppColors.primary : theme.hintColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
