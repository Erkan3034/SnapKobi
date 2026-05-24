import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

const _successGreen = Color(0xFF22C55E);

class ResultSuccessBanner extends ConsumerWidget {
  const ResultSuccessBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(resultProvider).processingDurationSec;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: _successGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: _successGreen, size: 20),
            const SizedBox(width: AppDimensions.spacing8),
            Text(
              'İşlem $seconds saniyede tamamlandı',
              style: AppTypography.labelLarge.copyWith(color: _successGreen),
            ),
          ],
        ),
      ),
    );
  }
}
