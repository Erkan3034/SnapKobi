// Üretim ilerleme halkası (yüzde göstergesi).
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/generation.dart';
import '../../../create/create_provider.dart';
import '../processing_provider.dart';

class ProcessingProgressRing extends ConsumerWidget {
  const ProcessingProgressRing({super.key});

  double _getProgress(AsyncValue<Generation?> state) {
    if (state.isLoading) return 0.05;
    if (state.hasError) return 1.0;
    final gen = state.value;
    if (gen == null) return 0.0;
    
    switch (gen.status) {
      case GenerationStatus.pending: return 0.1;
      case GenerationStatus.uploadingImage: return 0.25;
      case GenerationStatus.processingImage: return 0.5;
      case GenerationStatus.generatingCaption: return 0.75;
      case GenerationStatus.processingVideo: return 0.9;
      case GenerationStatus.completed: return 1.0;
      case GenerationStatus.failed: return 1.0;
      case GenerationStatus.cancelled: return 1.0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(processingProvider);
    final progress = _getProgress(state);
    final pct = (progress * 100).round();
    final imagePath = ref.watch(createProvider).selectedImagePath;

    return Column(
      children: [
        SizedBox(
          width: 160, height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160, height: 160,
                child: CircularProgressIndicator(
                  value: progress, strokeWidth: 6,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  child: imagePath != null
                      ? Hero(
                          tag: 'product_image_hero',
                          child: Image.file(File(imagePath), fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image, size: 40, color: AppColors.white),
                ),
              ),
              Positioned(top: 4, right: 4, child: Icon(Icons.auto_awesome, size: 18, color: AppColors.whiteOpacity(0.8))),
              Positioned(bottom: 8, left: 4, child: Icon(Icons.auto_awesome, size: 14, color: AppColors.whiteOpacity(0.6))),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        Text('$pct%', style: AppTypography.displayLarge.copyWith(color: AppColors.white)),
      ],
    );
  }
}

