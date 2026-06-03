// Ana sayfa üst 'Hemen Başla' banner'ı (dokununca /create açar).
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';

class QuickStartBanner extends StatelessWidget {
  final VoidCallback onTap;
  const QuickStartBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.spacing16),
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hemen Üretmeye Başla', style: AppTypography.titleLarge.copyWith(color: AppColors.white)),
            const SizedBox(height: AppDimensions.spacing4),
            Text('Ürününüzü çekin, AI gerisini halleder',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: 0.7))),
          ])),
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(AppIcons.ai, color: AppColors.white, size: 24),
          ),
        ]),
      ),
    );
  }
}
