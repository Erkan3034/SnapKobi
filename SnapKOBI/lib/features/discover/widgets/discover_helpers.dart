import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/feedback/shimmer_loading.dart';

Widget buildDiscoverShimmer() => const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppDimensions.spacing16),
        ShimmerLoading(width: double.infinity, height: 160, borderRadius: 16),
        SizedBox(height: AppDimensions.spacing20),
        ShimmerLoading(width: 150, height: 24, borderRadius: 4),
        SizedBox(height: AppDimensions.spacing12),
        Row(children: [
          Expanded(child: ShimmerLoading(width: double.infinity, height: 180, borderRadius: 16)),
          SizedBox(width: 12),
          Expanded(child: ShimmerLoading(width: double.infinity, height: 180, borderRadius: 16)),
        ]),
        SizedBox(height: AppDimensions.spacing24),
        ShimmerLoading(width: double.infinity, height: 120, borderRadius: 16),
      ],
    );

void showNotificationSheet(BuildContext context) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge))),
    builder: (context) => Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bildirimler 🔔', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(
            leading: const Icon(Icons.star, color: AppColors.warning),
            title: Text('Tebrikler! Yapay Zeka görseliniz hazırlandı.', style: theme.textTheme.bodyMedium),
            subtitle: Text('2 dakika önce', style: theme.textTheme.labelSmall),
          ),
          ListTile(
            leading: Icon(Icons.celebration, color: theme.colorScheme.primary),
            title: Text('Yeni trend şablonlar eklendi! Hemen dene.', style: theme.textTheme.bodyMedium),
            subtitle: Text('1 saat önce', style: theme.textTheme.labelSmall),
          ),
        ],
      ),
    ),
  );
}
