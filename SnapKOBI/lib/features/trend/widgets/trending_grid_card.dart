// Trendler ekranındaki trend grid kartı.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../../discover/discover_provider.dart';

class TrendingGridCard extends StatelessWidget {
  final TrendItem item;

  const TrendingGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayUsage = item.usageCount >= 1000
        ? '${(item.usageCount / 1000).toStringAsFixed(1)}k'
        : '${item.usageCount}';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.trendDetails, extra: item),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  url: item.imageUrl,
                  height: 140,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
                ),
                Positioned(
                  top: AppDimensions.spacing8,
                  left: AppDimensions.spacing8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: AppColors.white, size: 10),
                        const SizedBox(width: 2),
                        Text('BU HAFTA POPÜLER', style: AppTypography.labelSmall.copyWith(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTypography.titleLarge.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppDimensions.spacing4),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 14, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text('$displayUsage üretim', style: AppTypography.bodyMedium.copyWith(color: theme.hintColor, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryLightest, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                    child: Text(item.category.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => context.push(AppRoutes.create),
                      child: Text('Hemen Üret', style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
