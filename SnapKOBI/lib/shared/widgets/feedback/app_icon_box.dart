import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

/// Kare köşe yuvarlak ikon kutusu — İkon Kütüphanesi'ndeki görünüme uygun.
/// Kullanım: AppIconBox(icon: AppIcons.camera, label: 'Kamera')
class AppIconBox extends StatelessWidget {
  final IconData icon;
  final String? label;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppIconBox({
    super.key,
    required this.icon,
    this.label,
    this.size = 48,
    this.color,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryLightest;
    final fg = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(icon, color: fg, size: size * 0.5),
        ),
        if (label != null) ...[
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            label!,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ]),
    );
  }
}
