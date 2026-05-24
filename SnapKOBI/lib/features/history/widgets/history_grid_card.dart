import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../history_provider.dart';
import '../project_detail_screen.dart';

class HistoryGridCard extends StatelessWidget {
  final HistoryItem item;
  const HistoryGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProjectDetailScreen(item: item)),
      ),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
          child: AspectRatio(
            aspectRatio: 1.1,
            child: Image.network(item.imageUrl, fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.spacing8, AppDimensions.spacing8, AppDimensions.spacing8, 0),
          child: Text(item.title, style: AppTypography.titleLarge.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4, vertical: 2),
              decoration: BoxDecoration(
                color: item.platformLabel == 'IG' ? AppColors.primaryLightest : AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.spacing4),
              ),
              child: Text(item.platformLabel, style: AppTypography.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold, color: item.platformLabel == 'IG' ? AppColors.primary : AppColors.success)),
            ),
            const SizedBox(width: AppDimensions.spacing4),
            Expanded(child: Text(item.timeAgo, style: AppTypography.labelSmall.copyWith(color: AppColors.textHint), overflow: TextOverflow.ellipsis)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
          child: Row(children: [
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.ios_share, size: 14, color: AppColors.textSecondary),
              label: Text('Paylaş', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.bolt, size: 14, color: AppColors.primary),
              label: Text('Yeniden', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ]),
        ),
      ]),
    ));
  }
}
