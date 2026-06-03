// Açılış logo + parıltı (sparkle) ikonları.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class SplashLogoIcon extends StatelessWidget {
  const SplashLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.logoSize,
      height: AppDimensions.logoSize,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.whiteOpacity(0.15),
            blurRadius: 0,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.5),
            blurRadius: AppDimensions.spacing32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: SplashSparklesIcon(
          size: AppDimensions.logoIconSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class SplashSparklesIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SplashSparklesIcon({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklesPainter(color: color),
    );
  }
}

class _SparklesPainter extends CustomPainter {
  final Color color;
  const _SparklesPainter({required this.color});

  void _drawStar(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    final half = size / 2;
    final quarter = size / 6;
    path.moveTo(center.dx, center.dy - half);
    path.quadraticBezierTo(center.dx, center.dy - quarter, center.dx + half, center.dy);
    path.quadraticBezierTo(center.dx + quarter, center.dy, center.dx, center.dy + half);
    path.quadraticBezierTo(center.dx, center.dy + quarter, center.dx - half, center.dy);
    path.quadraticBezierTo(center.dx - quarter, center.dy, center.dx, center.dy - half);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    _drawStar(canvas, paint, Offset(size.width * 0.32, size.height * 0.60), size.width * 0.46);
    _drawStar(canvas, paint, Offset(size.width * 0.70, size.height * 0.30), size.width * 0.28);
    canvas.drawCircle(Offset(size.width * 0.76, size.height * 0.62), size.width * 0.06, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklesPainter old) => old.color != color;
}
