import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─── Marka Renkleri ──────────────────────────────────────────────
  static const Color primary = Color(0xFF6C3FC5);
  static const Color primaryDark = Color(0xFF2D0E6E);
  static const Color primaryMid = Color(0xFF5C2DB8);
  static const Color primaryLight = Color(0xFF7B3FE4);
  static const Color primaryLightest = Color(0xFFF3E8FF);

  // ─── Gradient ────────────────────────────────────────────────────
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryMid, primaryLight],
    stops: [0.0, 0.5, 1.0],
  );

  // ─── Nötr ────────────────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color indicatorInactive = Color(0xFFD1D5DB);

  // ─── Opaklık yardımcıları ────────────────────────────────────────
  static Color whiteOpacity(double opacity) =>
      Colors.white.withOpacity(opacity);
}
