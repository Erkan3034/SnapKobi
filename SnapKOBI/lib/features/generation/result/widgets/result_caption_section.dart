import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

class ResultCaptionSection extends ConsumerWidget {
  const ResultCaptionSection({super.key});

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
            Text('${s.platformLabel} Metni', style: AppTypography.titleLarge),
            const Spacer(),
            Chip(
              label: Text('📷 ${s.platformLabel}', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          Text(s.caption, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.spacing8),
          Wrap(
            spacing: AppDimensions.spacing4,
            runSpacing: AppDimensions.spacing4,
            children: s.hashtags
                .map((h) => Chip(
                      label: Text(h, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                      backgroundColor: AppColors.primaryLightest,
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('📋 Kopyala'))),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('✏ Düzenle'))),
          ]),
        ]),
      ),
    );
  }
}
