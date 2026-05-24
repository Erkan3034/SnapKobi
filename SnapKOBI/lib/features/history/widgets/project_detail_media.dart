import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';

class ProjectDetailMedia extends StatelessWidget {
  final String imageUrl;
  const ProjectDetailMedia({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('📸 İşlenmiş Görsel', style: AppTypography.titleLarge.copyWith(fontSize: 15)),
        const SizedBox(height: AppDimensions.spacing12),
        ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          child: Image.network(imageUrl, width: double.infinity, height: 180, fit: BoxFit.cover)),
        const SizedBox(height: AppDimensions.spacing12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () {}, icon: const Icon(AppIcons.download, size: 16),
            label: const Text('Kaydet'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: OutlinedButton.icon(
            onPressed: () {}, icon: const Icon(AppIcons.share, size: 16),
            label: const Text('Paylaş'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
        ]),
      ]),
    );
  }
}
