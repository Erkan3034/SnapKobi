import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../discover_provider.dart';

class TrendingCard extends StatelessWidget {
  final TrendItem item;
  final VoidCallback? onTap;
  const TrendingCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppDimensions.spacing12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          color: AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
            child: Image.network(item.imageUrl, height: 120, width: 160, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, style: AppTypography.titleLarge.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Row(children: [
                Icon(Icons.local_fire_department, size: 13, color: AppColors.warning),
                const SizedBox(width: 2),
                Text('${item.usageCount} üretim', style: AppTypography.labelSmall.copyWith(color: AppColors.textHint)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryLightest, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
                  child: Text(item.category, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 9)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
