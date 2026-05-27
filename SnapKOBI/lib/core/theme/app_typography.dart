import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
      );
}
