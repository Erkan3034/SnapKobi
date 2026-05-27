import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

class ResultSuccessBanner extends ConsumerWidget {
  const ResultSuccessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(resultProvider).processingDurationSec;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 14),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İşlem başarıyla tamamlandı! 🎉',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'SnapKOBİ Yapay Zekası tasarımı $seconds saniyede üretti.',
                    style: AppTypography.labelSmall.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
