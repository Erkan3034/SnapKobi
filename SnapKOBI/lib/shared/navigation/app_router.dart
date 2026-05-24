import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import 'app_routes_list.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final isLoggedIn = authState.valueOrNull != null;
  final isLoading = authState.isLoading;

  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: appRoutesList,
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
