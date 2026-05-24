import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

class ResultVideoSection extends ConsumerWidget {
  const ResultVideoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dur = ref.watch(resultProvider).videoDuration;
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
            Text('Tanıtım Videosu', style: AppTypography.titleLarge),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
              decoration: BoxDecoration(color: AppColors.primaryLightest, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
              child: Text(dur, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            child: Container(
              height: 160,
              decoration: const BoxDecoration(gradient: AppColors.splashGradient),
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 56, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('▶ Oynat'))),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('⬇ İndir'))),
          ]),
        ]),
      ),
    );
  }
}
