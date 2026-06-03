// Kesik çizgili çerçeve çizen CustomPainter (yükleme alanı kenarlığı).
import 'dart:ui';
import 'package:flutter/material.dart';

class DashedPainter extends CustomPainter {
  final Color color;
  final double radius;
  
  DashedPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );

    for (PathMetric metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        double end = start + 8.0;
        canvas.drawPath(metric.extractPath(start, end), paint);
        start = end + 6.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
