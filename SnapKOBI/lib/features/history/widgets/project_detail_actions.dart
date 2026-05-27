import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class ProjectDetailActions extends StatelessWidget {
  final VoidCallback? onRegenerate;
  final VoidCallback? onShareAll;
  const ProjectDetailActions({super.key, this.onRegenerate, this.onShareAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(children: [
        SizedBox(
          width: double.infinity, height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: onShareAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success, foregroundColor: AppColors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            ),
            child: Text('Tümünü Paylaş', style: AppTypography.labelLarge.copyWith(color: AppColors.white)),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          width: double.infinity, height: AppDimensions.buttonHeight,
          child: OutlinedButton(
            onPressed: onRegenerate,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            ),
            child: Text('🔄 Yeniden Üret', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ),
        ),
      ]),
    );
  }
}
