import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';

class ProjectDetailCaption extends StatelessWidget {
  final String platform;
  final String caption;
  final List<String> hashtags;
  const ProjectDetailCaption({super.key, required this.platform, required this.caption, required this.hashtags});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('📝 Platform Metni', style: AppTypography.titleLarge.copyWith(fontSize: 15)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
            decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            child: Text('📷 $platform', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        Text(caption, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppDimensions.spacing8),
        Wrap(spacing: 6, runSpacing: 4, children: hashtags.map((h) => Chip(
          label: Text(h, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
          backgroundColor: AppColors.primaryLightest, padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
        )).toList()),
        const SizedBox(height: AppDimensions.spacing12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(AppIcons.copy, size: 16),
            label: const Text('Kopyala'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(AppIcons.edit, size: 16),
            label: const Text('Düzenle'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
        ]),
      ]),
    );
  }
}
