import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../processing_provider.dart';

class ProcessingProgressRing extends ConsumerWidget {
  const ProcessingProgressRing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(processingProvider);
    final pct = (state.progress * 100).round();

    return Column(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160, height: 160,
                child: CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 6,
                  backgroundColor: AppColors.whiteOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.whiteOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: const Icon(Icons.image, size: 40, color: AppColors.white),
              ),
              Positioned(
                top: 4, right: 4,
                child: Icon(Icons.auto_awesome, size: 18,
                    color: AppColors.whiteOpacity(0.8)),
              ),
              Positioned(
                bottom: 8, left: 4,
                child: Icon(Icons.auto_awesome, size: 14,
                    color: AppColors.whiteOpacity(0.6)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        Text(
          '$pct%',
          style: AppTypography.displayLarge.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}
