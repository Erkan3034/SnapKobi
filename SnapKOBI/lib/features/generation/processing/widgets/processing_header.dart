// İşleniyor ekranı başlık bölümü.
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ProcessingHeader extends StatelessWidget {
  const ProcessingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
      ),
      child: Column(
        children: [
          Text(
            'İşleminiz Hazırlanıyor',
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Telefonu kapatabilirsiniz, bildirim göndereceğiz',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.whiteOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
