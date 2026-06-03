// Seçili platformu gösteren ve platform seçim sheet'ini açan çip buton.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/platform_type.dart';

const _platformLabels = {
  PlatformType.instagram: ('Instagram', AppIcons.platformInstagram),
  PlatformType.trendyol: ('Trendyol', AppIcons.platformTrendyol),
  PlatformType.whatsapp: ('WhatsApp', AppIcons.platformWhatsapp),
  PlatformType.web: ('Web Sitesi', AppIcons.platformWeb),
  PlatformType.tiktok: ('TikTok', AppIcons.platformTiktok),
};

/// Platform seçim gösterge çipi — tıklanınca bottom sheet açar.
class PlatformChipButton extends StatelessWidget {
  final PlatformType selectedPlatform;
  final VoidCallback onTap;
  const PlatformChipButton({super.key, required this.selectedPlatform, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final info = _platformLabels[selectedPlatform]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Platform', style: AppTypography.headlineMedium.copyWith(fontSize: 16, color: Theme.of(context).textTheme.titleLarge?.color ?? Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: AppDimensions.spacing8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: AppColors.primaryLightest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(info.$2, color: AppColors.primary, size: 18),
              const SizedBox(width: AppDimensions.spacing8),
              Text(info.$1, style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
              const SizedBox(width: AppDimensions.spacing8),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 18),
            ]),
          ),
        ),
      ]),
    );
  }
}
