import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class PlanCardStarter extends StatelessWidget {
  final int price;
  const PlanCardStarter({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Başlangıç', style: AppTypography.headlineMedium.copyWith(color: AppColors.white)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12, vertical: AppDimensions.spacing4),
            decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            child: Text('EN POPÜLER', style: AppTypography.labelSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          ),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$price ₺', style: AppTypography.displayMedium.copyWith(color: AppColors.white)),
          Text(' / ay', style: AppTypography.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: 0.7))),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        ...planStarter.features.map((f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
          child: Row(children: [
            const Icon(Icons.check_circle, size: 18, color: AppColors.white),
            const SizedBox(width: AppDimensions.spacing8),
            Text(f.text, style: AppTypography.bodyMedium.copyWith(color: AppColors.white)),
          ]),
        )),
        const SizedBox(height: AppDimensions.spacing16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white, foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12), elevation: 0,
            ),
            child: Text('Başla — 7 Gün Ücretsiz', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ),
        ),
      ]),
    );
  }
}
