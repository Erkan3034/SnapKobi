import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/constants/app_constants.dart';
import '../../discover/discover_provider.dart';

class TrendHeroCard extends StatelessWidget {
  final TrendItem item;

  const TrendHeroCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final displayUsage = item.usageCount >= 1000
        ? '${(item.usageCount / 1000).toStringAsFixed(1)}k+'
        : '${item.usageCount}';

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(item.imageUrl, fit: BoxFit.cover),
            _buildPopularBadge(),
            _buildFrostedGlassInfo(displayUsage),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularBadge() {
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

  Widget _buildFrostedGlassInfo(String usage) {
    return Positioned(
      bottom: AppDimensions.spacing16,
      left: AppDimensions.spacing16,
      right: AppDimensions.spacing16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            color: AppColors.whiteOpacity(0.25),
            child: Row(
              children: [
                const Icon(AppIcons.ai, color: AppColors.primaryLightest, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$usage kez üretildi',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _buildAvatarStack(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    final avatarUrls = AppConstants.mockAvatars;

    return SizedBox(
      width: 60,
      height: 28,
      child: Stack(
        children: List.generate(avatarUrls.length, (index) {
          return Positioned(
            right: index * 14.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(avatarUrls[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
