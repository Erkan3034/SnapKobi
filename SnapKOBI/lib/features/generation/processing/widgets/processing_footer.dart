import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/generation.dart';
import '../processing_provider.dart';

class ProcessingFooter extends ConsumerWidget {
  const ProcessingFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(processingProvider);
    final secs = state.maybeWhen(
      data: (gen) {
        if (gen == null) return 30;
        switch (gen.status) {
          case GenerationStatus.pending:
          case GenerationStatus.uploadingImage:
            return 30;
          case GenerationStatus.processingImage:
            return 20;
          case GenerationStatus.generatingCaption:
          case GenerationStatus.processingVideo:
            return 10;
          default:
            return 0;
        }
      },
      orElse: () => 30,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 16,
                  color: AppColors.whiteOpacity(0.8)),
              const SizedBox(width: AppDimensions.spacing4),
              Text('Tahmini Süre: ~$secs saniye',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.whiteOpacity(0.8)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.coffee, size: 18),
            label: const Text('Arka Planda Çalışsın'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.white,
              side: BorderSide(color: AppColors.whiteOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing24,
                vertical: AppDimensions.spacing12,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            'İşlem tamamlandığında bildirim alacaksınız 🔔',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.whiteOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
