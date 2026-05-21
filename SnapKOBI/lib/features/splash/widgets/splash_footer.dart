import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class SplashFooter extends StatelessWidget {
  final double progressValue;

  const SplashFooter({super.key, required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.spacing40,
        right: AppDimensions.spacing40,
        bottom: AppDimensions.spacing32,
      ),
      child: Column(
        children: [
          _SplashProgressBar(value: progressValue),
          const SizedBox(height: AppDimensions.spacing20),
          Text(
            AppStrings.appDomain,
            style: TextStyle(
              color: AppColors.whiteOpacity(0.4),
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashProgressBar extends StatelessWidget {
  final double value;

  const _SplashProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: AppDimensions.progressBarHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: AppColors.whiteOpacity(0.2),
            borderRadius: BorderRadius.circular(AppDimensions.progressBarHeight / 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteOpacity(0.85),
                  borderRadius: BorderRadius.circular(AppDimensions.progressBarHeight / 2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
