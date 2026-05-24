import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../discover_provider.dart';

class CommunityCard extends StatelessWidget {
  final CommunityItem item;
  const CommunityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing4),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 14, backgroundColor: AppColors.primaryLightest,
            child: Text(item.userName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('@${item.userName}', style: AppTypography.labelLarge.copyWith(fontSize: 12)),
            Text('${item.platform} · ${item.timeAgo}', style: AppTypography.labelSmall.copyWith(color: AppColors.textHint, fontSize: 10)),
          ])),
        ]),
        const SizedBox(height: AppDimensions.spacing8),
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: Image.network(item.beforeUrl, height: 100, fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
            child: Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
          ),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: Image.network(item.afterUrl, height: 100, fit: BoxFit.cover))),
        ]),
      ]),
    );
  }
}
