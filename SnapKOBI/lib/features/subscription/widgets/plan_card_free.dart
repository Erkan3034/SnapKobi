import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class PlanCardFree extends StatelessWidget {
  final int price;
  const PlanCardFree({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ücretsiz', style: AppTypography.headlineMedium),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$price ₺', style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary)),
          Text(' / ay', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        ...planFree.features.map((f) => _featureRow(f)),
        const SizedBox(height: AppDimensions.spacing16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
            ),
            child: Text('Mevcut Plan', style: AppTypography.labelLarge.copyWith(color: AppColors.textHint)),
          ),
        ),
      ]),
    );
  }

  Widget _featureRow(PlanFeature f) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
      child: Row(children: [
        Icon(f.included ? Icons.check_circle : Icons.cancel, size: 18,
            color: f.included ? AppColors.success : AppColors.textHint),
        const SizedBox(width: AppDimensions.spacing8),
        Text(f.text, style: AppTypography.bodyMedium.copyWith(
          color: f.included ? AppColors.textPrimary : AppColors.textHint,
        )),
      ]),
    );
  }
}
