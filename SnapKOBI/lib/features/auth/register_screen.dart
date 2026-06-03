// Kayıt ekranı: yeni hesap oluşturma formu (e-posta/şifre/ad/telefon). Rota: /register
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/auth_error.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/validators/email_validator.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/social_login_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showError(AppStrings.authEmailRequired);
      return;
    }
    if (!EmailValidator.isValid(email)) {
      _showError(AppStrings.authInvalidEmail);
      return;
    }
    if (password.isEmpty) {
      _showError(AppStrings.authPasswordRequired);
      return;
    }
    if (password.length < AppConstants.minPasswordLength) {
      _showError(AppStrings.authWeakPassword);
      return;
    }

    ref.read(authNotifierProvider.notifier).signUpWithEmail(
          email: email,
          password: password,
          displayName: name.isEmpty ? null : name,
          phone: phone.isEmpty ? null : phone,
        );
  }

  void _onGoogleRegister() {
    ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  void _onAppleRegister() {
    ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        if (!mounted) return;
        if (error is AuthError && error.code == 'EMAIL_VERIFICATION_REQUIRED') {
          _showInfo(error.message);
          final email = _emailController.text.trim();
          final next = email.isEmpty
              ? AppRoutes.verifyEmail
              : '${AppRoutes.verifyEmail}?email=${Uri.encodeComponent(email)}';
          context.go(next);
          return;
        }

        final message = error is AppError ? error.message : AppStrings.authGenericError;
        _showError(message);
      }

      final nextUser = next.valueOrNull;
      final prevUser = previous?.valueOrNull;
      if (prevUser == null && nextUser != null) {
        if (!mounted) return;
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimensions.spacing24),
                    _buildHeader(),
                    const SizedBox(height: AppDimensions.spacing32),

                    // Sosyal Girişler
                    SocialLoginButton(
                      type: SocialLoginType.google,
                      text: AppStrings.registerGoogle,
                      onPressed: isLoading ? null : _onGoogleRegister,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    SocialLoginButton(
                      type: SocialLoginType.apple,
                      text: AppStrings.registerApple,
                      onPressed: isLoading ? null : _onAppleRegister,
                    ),

                    const SizedBox(height: AppDimensions.spacing24),
                    _buildDivider(),
                    const SizedBox(height: AppDimensions.spacing24),

                    // Form Alanlari
                    CustomTextField(
                      hintText: AppStrings.registerNameHint,
                      prefixIcon: Icons.person_outline,
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    CustomTextField(
                      hintText: AppStrings.registerEmailHint,
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    CustomTextField(
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
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    _buildPhoneInput(isLoading: isLoading),

                    const SizedBox(height: AppDimensions.spacing24),
                    _buildTermsText(),
                    const SizedBox(height: AppDimensions.spacing40),
                  ],
                ),
              ),
            ),
            _buildBottomButton(isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              _buildDot(isActive: false),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: false),
              const SizedBox(width: AppDimensions.spacing8),
              _buildDot(isActive: true),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.primary),
            onPressed: () {},
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

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.registerTitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppDimensions.fontXL,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          AppStrings.registerSubtitle,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: AppDimensions.fontMD,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: theme.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: Text(
            AppStrings.registerOrEmail,
            style: TextStyle(
              color: theme.hintColor,
              fontSize: AppDimensions.fontSM,
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.dividerColor)),
      ],
    );
  }

  Widget _buildPhoneInput({required bool isLoading}) {
    return CustomTextField(
      hintText: AppStrings.registerPhoneHint,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      enabled: !isLoading,
      textInputAction: TextInputAction.done,
      prefixWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: AppDimensions.spacing16),
          Icon(Icons.phone_outlined, color: Theme.of(context).hintColor, size: 20),
          const SizedBox(width: AppDimensions.spacing8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLightest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Row(
              children: [
                const Text('🇹🇷', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  '+90',
                  style: TextStyle(
                    color: AppColors.primaryMid,
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.fontSM,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: theme.hintColor,
          fontSize: AppDimensions.fontSM,
          height: 1.4,
        ),
        children: [
          const TextSpan(text: AppStrings.registerTermsPrefix),
          const TextSpan(
            text: AppStrings.registerTermsLink,
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: AppStrings.registerTermsAnd),
          const TextSpan(
            text: AppStrings.registerPrivacyLink,
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: AppStrings.registerTermsSuffix),
        ],
      ),
    );
  }

  Widget _buildBottomButton({required bool isLoading}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
        vertical: AppDimensions.spacing16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : _onRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            elevation: 0,
          ),
          child: const Text(
            AppStrings.registerSubmit,
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
