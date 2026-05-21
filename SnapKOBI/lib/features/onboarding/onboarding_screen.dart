import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_hero.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Onboarding'de status bar yine şeffaf ve açık renk (arkaplandaki gradient'ten dolayı)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Üst Kısım: Curved Gradient & İmajlar
          const Expanded(
            flex: 5,
            child: OnboardingHero(),
          ),
          
          // Alt Kısım: Metinler & Butonlar
          Expanded(
            flex: 5,
            child: OnboardingContent(
              onStartPressed: () {
                context.go(AppRoutes.onboardingSector);
              },
              onLoginPressed: () {
                // Zaten hesabım var -> Login
                context.go(AppRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}

