import 'package:go_router/go_router.dart';

import '../../features/auth/email_verification_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/generation/result/result_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/onboarding_sector_screen.dart';
import '../../features/settings/screens/help_faq_screen.dart';
import '../../features/settings/screens/language_settings_screen.dart';
import '../../features/settings/screens/privacy_policy_screen.dart';
import '../../features/settings/screens/profile_info_screen.dart';
import '../../features/settings/screens/sector_settings_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/subscription/payment_history_screen.dart';
import '../../features/subscription/subscription_screen.dart';
import '../widgets/layout/main_scaffold.dart';
import 'routes.dart';

final List<RouteBase> appRoutesList = [
  GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
  GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
  GoRoute(path: AppRoutes.onboardingSector, builder: (_, __) => const OnboardingSectorScreen()),
  GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
  GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
  GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
  GoRoute(path: AppRoutes.resetPassword, builder: (_, __) => const ResetPasswordScreen()),
  GoRoute(path: AppRoutes.verifyEmail, builder: (_, state) => EmailVerificationScreen(email: state.uri.queryParameters['email'])),
  GoRoute(path: AppRoutes.home, builder: (_, __) => const MainScaffold()),
  GoRoute(path: AppRoutes.results, builder: (_, __) => const ResultScreen()),
  GoRoute(path: AppRoutes.history, builder: (_, __) => const HistoryScreen()),
  GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
  GoRoute(path: AppRoutes.subscription, builder: (_, __) => const SubscriptionScreen()),
  GoRoute(path: AppRoutes.profileInfo, builder: (_, __) => const ProfileInfoScreen()),
  GoRoute(path: AppRoutes.sectorSettings, builder: (_, __) => const SectorSettingsScreen()),
  GoRoute(path: AppRoutes.paymentHistory, builder: (_, __) => const PaymentHistoryScreen()),
  GoRoute(path: AppRoutes.helpFaq, builder: (_, __) => const HelpFaqScreen()),
  GoRoute(path: AppRoutes.privacyPolicy, builder: (_, __) => const PrivacyPolicyScreen()),
  GoRoute(path: AppRoutes.languageSettings, builder: (_, __) => const LanguageSettingsScreen()),
];
