import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/validators/email_validator.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
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

    ref.read(authNotifierProvider.notifier).signInWithEmail(
          email: email,
          password: password,
        );
  }

  void _onGoogleLogin() {
    ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  void _onAppleLogin() {
    ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  void _onSignUp() {
    // Kayıt ekranına git
    context.go(AppRoutes.register);
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
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacing24),
              _buildHeader(),
              const SizedBox(height: AppDimensions.spacing32),
              
              // Sosyal Girişler
              SocialLoginButton(
                type: SocialLoginType.google,
                text: AppStrings.loginGoogle,
                onPressed: isLoading ? null : _onGoogleLogin,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              SocialLoginButton(
                type: SocialLoginType.apple,
                text: AppStrings.loginApple,
                onPressed: isLoading ? null : _onAppleLogin,
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              _buildDivider(),
              const SizedBox(height: AppDimensions.spacing24),
              
              // Form Alanları
              CustomTextField(
                label: AppStrings.loginEmailLabel,
                hintText: AppStrings.loginEmailHint,
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailController,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppDimensions.spacing20),
              CustomTextField(
                label: AppStrings.loginPasswordLabel,
                hintText: AppStrings.loginPasswordHint,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                controller: _passwordController,
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
              
              // Şifremi Unuttum
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    AppStrings.loginForgotPassword,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacing32),
              
              // Giriş Yap Butonu
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    AppStrings.loginSubmit,
                    style: TextStyle(
                      fontSize: AppDimensions.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacing24),
              
              // Kayıt Ol Linki
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.loginNoAccount,
                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: AppDimensions.fontSM,
                    ),
                  ),
                  TextButton(
                    onPressed: _onSignUp,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      AppStrings.loginSignUp,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSM,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacing40),
              
              // Alt Bilgi Kartı
              _buildInfoBanner(),
              
              const SizedBox(height: AppDimensions.spacing40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppStrings.loginAppBarTitle,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppDimensions.fontMD,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          AppStrings.loginTitle,
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: AppDimensions.font2XL,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).hintColor,
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
            AppStrings.registerOrEmail, // 'veya e-posta ile' - aynı metin
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

  Widget _buildInfoBanner() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLightest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(
              Icons.auto_awesome, // Yıldız / Sparkle ikonu alternatifi
              color: AppColors.primaryDark,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.loginBannerTitle,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: AppDimensions.fontSM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  AppStrings.loginBannerDesc,
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 12, // AppDimensions.fontXS (11) ile SM (13) arası
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
