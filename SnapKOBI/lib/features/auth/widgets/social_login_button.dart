import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

enum SocialLoginType { google, apple }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final String text;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = type == SocialLoginType.google;

    return SizedBox(
      height: AppDimensions.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGoogle ? AppColors.white : AppColors.black,
          foregroundColor: isGoogle ? AppColors.textPrimary : AppColors.white,
          elevation: isGoogle ? 1 : 0,
          shadowColor: AppColors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            side: isGoogle
                ? BorderSide(color: AppColors.borderLight, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkon (basit yer tutucu, gerçek assetlerle değiştirilebilir)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isGoogle ? AppColors.white : AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isGoogle ? 'G' : '',
                  style: TextStyle(
                    color: isGoogle ? Colors.red : AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Text(
              text,
              style: TextStyle(
                fontSize: AppDimensions.fontMD,
                fontWeight: FontWeight.w500,
                color: isGoogle ? AppColors.textPrimary : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
