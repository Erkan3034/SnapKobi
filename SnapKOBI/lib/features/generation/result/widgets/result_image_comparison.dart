import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

class ResultImageComparison extends ConsumerWidget {
  const ResultImageComparison({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(resultProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Görsel Karşılaştırma', style: AppTypography.titleLarge),
            const Spacer(),
            TextButton(onPressed: () {}, child: Text('Kaydet 💾', style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            _imageCard('Önce', s.originalImageUrl),
            const SizedBox(width: AppDimensions.spacing8),
            _imageCard('Sonra', s.processedImageUrl),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          Center(
            child: Text('⭐⭐⭐⭐⭐ Yüksek Kalite', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          ),
        ]),
      ),
    );
  }

  Widget _imageCard(String label, String url) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Stack(children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(url, fit: BoxFit.cover),
          ),
          Positioned(
            left: AppDimensions.spacing4,
            top: AppDimensions.spacing4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
              decoration: BoxDecoration(color: AppColors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
              child: Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}
