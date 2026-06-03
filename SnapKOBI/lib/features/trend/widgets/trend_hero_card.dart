// Trend detay üst kapak kartı.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../shared/widgets/image/before_after_slider.dart';
import '../../discover/discover_provider.dart';
import 'trend_frosted_glass_info.dart';
import 'trend_popular_badge.dart';

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
            BeforeAfterSlider(beforeUrl: item.beforeUrl, afterUrl: item.imageUrl, height: 400),
            const TrendPopularBadge(),
            TrendFrostedGlassInfo(usage: displayUsage),
          ],
        ),
      ),
    );
  }
}
