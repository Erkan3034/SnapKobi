// Yeni şifre belirleme ekranı (passwordRecovery olayından sonra açılır). Rota: /reset-password
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/custom_text_field.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.isEmpty || confirm.isEmpty) {
      _showError(AppStrings.authPasswordRequired);
      return;
    }
    if (password.length < AppConstants.minPasswordLength) {
      _showError(AppStrings.authWeakPassword);
      return;
    }
    if (password != confirm) {
      _showError(AppStrings.authPasswordMismatch);
      return;
    }

    final result = await ref.read(authNotifierProvider.notifier).updatePassword(
          newPassword: password,
        );

    result.fold(
      onSuccess: (_) async {
        await ref.read(authNotifierProvider.notifier).signOut();
        if (!mounted) return;
        _showInfo(AppStrings.resetPasswordSuccess);
        context.go(AppRoutes.login);
      },
      onFailure: (error) => _showError(error.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.resetPasswordTitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
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
              Text(
                AppStrings.resetPasswordSubtitle,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: AppDimensions.fontMD,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              CustomTextField(
                label: AppStrings.resetPasswordNewLabel,
                hintText: AppStrings.loginPasswordHint,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: theme.hintColor,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              CustomTextField(
                label: AppStrings.resetPasswordConfirmLabel,
                hintText: AppStrings.loginPasswordHint,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                controller: _confirmController,
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: theme.hintColor,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacing32),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.resetPasswordSubmit,
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
