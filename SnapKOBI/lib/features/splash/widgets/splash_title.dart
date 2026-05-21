import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.appName,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: AppDimensions.font2XL,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          AppStrings.appTagline,
          style: TextStyle(
            color: AppColors.whiteOpacity(0.75),
            fontSize: AppDimensions.fontMD,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
