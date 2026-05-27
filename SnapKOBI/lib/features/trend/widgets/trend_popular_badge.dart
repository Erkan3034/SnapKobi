import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class TrendPopularBadge extends StatelessWidget {
  const TrendPopularBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppDimensions.spacing16,
      left: AppDimensions.spacing16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'Bu Hafta Popüler',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
