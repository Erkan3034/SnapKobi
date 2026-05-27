import 'package:flutter/material.dart';

import 'app_theme_dark.dart';
import 'app_theme_light.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => getLightAppTheme();
  static ThemeData get darkTheme => getDarkAppTheme();
}
