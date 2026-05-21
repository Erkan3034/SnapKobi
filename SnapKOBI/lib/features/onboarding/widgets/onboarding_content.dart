import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class OnboardingContent extends StatelessWidget {
  final VoidCallback onStartPressed;
  final VoidCallback onLoginPressed;

  const OnboardingContent({
    super.key,
    required this.onStartPressed,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
        vertical: AppDimensions.spacing32,
      ),
      child: Column(
        children: [
          // Sayfa İndikatörü
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(isActive: true),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: false),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: false),
            ],
          ),
          
          const Spacer(),

          // Başlık ve Açıklama
          Text(
            AppStrings.onboardingTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            AppStrings.onboardingDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimensions.fontSM,
              height: 1.5,
            ),
          ),

          const Spacer(),

          // Başla Butonu
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: onStartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                ),
                elevation: 0,
              ),
              child: const Text(
                AppStrings.onboardingButton,
                style: TextStyle(
                  fontSize: AppDimensions.fontMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacing16),

          // Giriş Yap Linki
          TextButton(
            onPressed: onLoginPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text(
              AppStrings.onboardingLogin,
              style: TextStyle(
                fontSize: AppDimensions.fontMD,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.indicatorInactive,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
