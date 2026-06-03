// Açılış ekranı: oturum kontrolü yapar ve ilk yönlendirmeyi belirler. Rota: /
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/di/providers.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/splash_footer.dart';
import 'widgets/splash_logo.dart';
import 'widgets/splash_title.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  bool _isDisposed = false;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _progressController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _setupAnimations();
    _runSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_isDisposed || !mounted) return;
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (_isDisposed || !mounted) return;
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (_isDisposed || !mounted) return;
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    final user = await _getCurrentUser();
    final nextRoute = user == null ? AppRoutes.onboarding : AppRoutes.home;
    if (!mounted) return;
    context.go(nextRoute);
  }

  Future<Object?> _getCurrentUser() async {
    try {
      return await ref.read(authNotifierProvider.future);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildCenter()),
              AnimatedBuilder(
                animation: _progressController,
                builder: (_, __) => SplashFooter(progressValue: _progressValue.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenter() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _logoController,
            builder: (_, __) => Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: const SplashLogoIcon(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing28),
          AnimatedBuilder(
            animation: _textController,
            builder: (_, __) => Opacity(
              opacity: _textOpacity.value,
              child: Transform.translate(
                offset: Offset(0, _textSlide.value),
                child: const SplashTitle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
