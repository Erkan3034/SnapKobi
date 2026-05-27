import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

ThemeData getDarkAppTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9F67FF),
        secondary: Color(0xFFC084FC),
        surface: Color(0xFF140F27),
        onSurface: Color(0xFFE5E7EB),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFF0C091A),
      cardColor: const Color(0xFF140F27),
      dividerColor: const Color(0xFF2E244E),
      hintColor: const Color(0xFF6B7280),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: const Color(0xFFFFFFFF)),
        displayMedium: AppTypography.displayMedium.copyWith(color: const Color(0xFFFFFFFF)),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: const Color(0xFFFFFFFF)),
        titleLarge: AppTypography.titleLarge.copyWith(color: const Color(0xFFFFFFFF)),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: const Color(0xFFE5E7EB)),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: const Color(0xFF9CA3AF)),
        labelLarge: AppTypography.labelLarge.copyWith(color: const Color(0xFFFFFFFF)),
        labelSmall: AppTypography.labelSmall.copyWith(color: const Color(0xFF6B7280)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF140F27),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: Color(0xFF140F27),
        elevation: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9F67FF),
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF140F27),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2E244E),
        selectedColor: const Color(0xFF9F67FF),
        labelStyle: AppTypography.bodyMedium.copyWith(fontSize: 13, color: const Color(0xFFC084FC)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF140F27),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF2E244E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF2E244E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF9F67FF), width: 2),
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(color: const Color(0xFF6B7280)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
