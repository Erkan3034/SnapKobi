import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/providers.dart';
import 'core/theme/app_theme.dart';
import 'shared/navigation/app_router.dart';
import 'shared/navigation/routes.dart';

class SnapKobiApp extends ConsumerStatefulWidget {
  const SnapKobiApp({super.key});

  @override
  ConsumerState<SnapKobiApp> createState() => _SnapKobiAppState();
}

class _SnapKobiAppState extends ConsumerState<SnapKobiApp> {
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;
      final event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        ref.read(appRouterProvider).go(AppRoutes.resetPassword);
        return;
      }

      if (event == AuthChangeEvent.signedOut) {
        ref.read(authNotifierProvider.notifier).setSignedOut();
        return;
      }

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed ||
          event == AuthChangeEvent.userUpdated ||
          event == AuthChangeEvent.initialSession) {
        ref.read(authNotifierProvider.notifier).refreshCurrentUser();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'SnapKobi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
