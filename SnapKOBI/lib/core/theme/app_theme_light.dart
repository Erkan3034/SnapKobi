import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

ThemeData getLightAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryMid,
        surface: AppColors.white,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.white,
      dividerColor: AppColors.borderLight,
      hintColor: AppColors.textHint,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimary),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textHint),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: AppColors.white,
        elevation: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLightest,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.bodyMedium.copyWith(fontSize: 13, color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
