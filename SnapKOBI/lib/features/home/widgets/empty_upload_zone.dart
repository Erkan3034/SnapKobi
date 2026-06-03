// Henüz foto seçilmemiş boş yükleme alanı görseli.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'dashed_painter.dart';

class EmptyUploadZone extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyUploadZone({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedPainter(color: AppColors.primary, radius: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLightest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 48, color: AppColors.primary),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                'Ürün Fotoğrafı Ekle',
                style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              Text(
                'Galeriden seç veya kamera ile çek',
                style: AppTypography.bodyMedium.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
