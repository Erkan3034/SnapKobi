import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/discover_provider.dart';

class TrendStatsRow extends StatelessWidget {
  final TrendItem item;

  const TrendStatsRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      child: Row(
        children: [
          _buildStatChip(
            icon: Icons.checkroom,
            iconColor: AppColors.primary,
            labelPrefix: 'Sektör: ',
            labelValue: item.sector,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          _buildStatChip(
            icon: Icons.trending_up,
            iconColor: AppColors.success,
            labelPrefix: 'Popülerlik: ',
            labelValue: item.popularity,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          _buildStatChip(
            icon: Icons.share_outlined,
            iconColor: AppColors.primary,
            labelPrefix: 'Platform: ',
            labelValue: item.platform,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required Color iconColor,
    required String labelPrefix,
    required String labelValue,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          RichText(
            text: TextSpan(
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              children: [
                TextSpan(text: labelPrefix),
                TextSpan(
                  text: labelValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
