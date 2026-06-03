// Proje detay başlık bölümü.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../history_provider.dart';

class ProjectDetailHeader extends StatelessWidget {
  final HistoryItem item;
  const ProjectDetailHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      AppNetworkImage(
        url: item.imageUrl,
        width: double.infinity,
        height: 280,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      const SizedBox(height: AppDimensions.spacing16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title, style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color)),
          const SizedBox(height: AppDimensions.spacing4),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
              child: Text('📷 ${item.platformLabel}', style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.primary)),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Text(item.timeAgo, style: AppTypography.bodyMedium.copyWith(color: theme.hintColor)),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: List.generate(5, (i) =>
            Icon(Icons.star, size: 16, color: i < 4 ? AppColors.warning : theme.disabledColor))),
        ]),
      ),
    ]);
  }
}
