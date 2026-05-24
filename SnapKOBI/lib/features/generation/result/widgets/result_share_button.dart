import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

const _successGreen = Color(0xFF22C55E);

class ResultShareButton extends StatelessWidget {
  const ResultShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
      ),
      child: SizedBox(
        height: AppDimensions.buttonHeight,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: _successGreen,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            elevation: 0,
          ),
          child: Text(
            'Tümünü Paylaş',
            style: AppTypography.labelLarge.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
