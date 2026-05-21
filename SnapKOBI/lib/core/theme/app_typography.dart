import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 32.0,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 26.0,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => GoogleFonts.nunito(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.rubik(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => GoogleFonts.rubik(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelLarge => GoogleFonts.rubik(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelSmall => GoogleFonts.rubik(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
      );
}
