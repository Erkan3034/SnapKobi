// E-posta doğrulama ekranı: kayıt sonrası 'mailini kontrol et' bilgisini gösterir. Rota: /verify-email
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: Text(
          AppStrings.verifyEmailTitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
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
              Text(
                AppStrings.verifyEmailSubtitle,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: AppDimensions.fontMD,
                ),
              ),
              if (email != null && email!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacing24),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    '${AppStrings.verifyEmailSentTo}${email!}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
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
