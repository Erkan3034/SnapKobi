import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../discover_provider.dart';

class TrendingCard extends StatelessWidget {
  final TrendItem item;
  final VoidCallback? onTap;
  const TrendingCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap ?? () => context.push(AppRoutes.trendDetails, extra: item),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppDimensions.spacing12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          color: theme.cardTheme.color ?? theme.cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppNetworkImage(
            url: item.imageUrl,
            height: 120,
            width: 160,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, style: AppTypography.titleLarge.copyWith(fontSize: 14, color: theme.textTheme.titleLarge?.color), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.local_fire_department, size: 13, color: AppColors.warning),
                const SizedBox(width: 2),
                Text('${item.usageCount} üretim', style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
                  child: Text(item.category, style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.primary, fontSize: 9)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
