import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x146C3FC5), // rgba(108, 63, 197, 0.08)
    offset: Offset(0, 2),
    blurRadius: 8.0,
  );

  static const BoxShadow modalShadow = BoxShadow(
    color: Color(0x296C3FC5), // rgba(108, 63, 197, 0.16)
    offset: Offset(0, 8),
    blurRadius: 32.0,
  );

  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x4D6C3FC5), // rgba(108, 63, 197, 0.30)
    offset: Offset(0, 4),
    blurRadius: 12.0,
  );
}
