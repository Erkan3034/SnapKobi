import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/email_verification_screen.dart';
import '../../features/generation/result/result_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/onboarding_sector_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/widgets/layout/main_scaffold.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final isLoggedIn = authState.valueOrNull != null;
  final isLoading = authState.isLoading;

  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingSector,
        builder: (context, state) => const OnboardingSectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: AppRoutes.results,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (location == AppRoutes.splash) return null;
      if (isLoading) return null;

      const publicRoutes = <String>{
        AppRoutes.onboarding,
        AppRoutes.onboardingSector,
        AppRoutes.register,
        AppRoutes.login,
        AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
        AppRoutes.verifyEmail,
      };

      if (!isLoggedIn && !publicRoutes.contains(location)) {
        return AppRoutes.login;
      }

      if (isLoggedIn && publicRoutes.contains(location) && location != AppRoutes.resetPassword) {
        return AppRoutes.home;
      }

      return null;
    },
  );
});
