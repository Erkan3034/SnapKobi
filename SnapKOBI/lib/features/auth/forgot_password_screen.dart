import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../core/di/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/validators/email_validator.dart';
import 'widgets/custom_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError(AppStrings.authEmailRequired);
      return;
    }
    if (!EmailValidator.isValid(email)) {
      _showError(AppStrings.authInvalidEmail);
      return;
    }

    final result = await ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(
          email: email,
        );

    result.fold(
      onSuccess: (_) => _showInfo(AppStrings.forgotPasswordSent),
      onFailure: (error) => _showError(error.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.forgotPasswordTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppDimensions.fontMD,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacing24),
              const Text(
                AppStrings.forgotPasswordSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimensions.fontMD,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              CustomTextField(
                label: AppStrings.forgotPasswordEmailLabel,
                hintText: AppStrings.forgotPasswordEmailHint,
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                controller: _emailController,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppDimensions.spacing32),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.forgotPasswordSubmit,
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

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showInfo(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
