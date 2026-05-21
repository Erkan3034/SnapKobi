import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/platform_type.dart';

class PlatformSelector extends StatelessWidget {
  final PlatformType selectedPlatform;
  final ValueChanged<PlatformType> onPlatformSelected;

  const PlatformSelector({
    super.key,
    required this.selectedPlatform,
    required this.onPlatformSelected,
  });

  static const _platforms = [
    (PlatformType.instagram, '📸 Instagram'),
    (PlatformType.trendyol, '🛍️ Trendyol'),
    (PlatformType.whatsapp, '💬 WhatsApp'),
    (PlatformType.web, '🌐 Web Sitesi'),
    (PlatformType.tiktok, '🎵 TikTok'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Text(
            'Platform Seçin',
            style: AppTypography.headlineMedium.copyWith(fontSize: 16, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Row(
            children: _platforms.map((platform) {
              final isSelected = selectedPlatform == platform.$1;
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spacing8),
                child: ChoiceChip(
                  label: Text(platform.$2),
                  selected: isSelected,
                  onSelected: (_) => onPlatformSelected(platform.$1),
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : AppColors.primary,
                      width: 1,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
