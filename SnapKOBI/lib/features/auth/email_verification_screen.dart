import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../shared/navigation/routes.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String? email;

  const EmailVerificationScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: const Text(
          AppStrings.verifyEmailTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppDimensions.fontMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacing24),
              const Text(
                AppStrings.verifyEmailSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimensions.fontMD,
                ),
              ),
              if (email != null && email!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacing24),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${AppStrings.verifyEmailSentTo}${email!}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.verifyEmailGoToLogin,
                    style: TextStyle(
                      fontSize: AppDimensions.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
