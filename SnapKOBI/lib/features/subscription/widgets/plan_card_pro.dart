import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class PlanCardPro extends StatelessWidget {
  final int price;
  const PlanCardPro({super.key, required this.price});

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
        Row(children: [
          Text('Pro', style: AppTypography.headlineMedium),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12, vertical: AppDimensions.spacing4),
            decoration: BoxDecoration(
              color: AppColors.primaryLightest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
              const SizedBox(width: AppDimensions.spacing4),
              Text('PRO', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$price ₺', style: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary)),
          Text(' / ay', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        ...planPro.features.map((f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
          child: Row(children: [
            const Icon(Icons.check_circle, size: 18, color: AppColors.success),
            const SizedBox(width: AppDimensions.spacing8),
            Text(f.text, style: AppTypography.bodyMedium),
          ]),
        )),
        const SizedBox(height: AppDimensions.spacing16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text("Pro'ya Geç", style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ),
        ),
      ]),
    );
  }
}
