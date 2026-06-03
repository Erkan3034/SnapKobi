// Onboarding üst görsel/illüstrasyon kartı.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.splashGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing24,
            vertical: AppDimensions.spacing40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sol Kart (Ham Çekim)
              const _ImageCard(
                title: AppStrings.onboardingRawImage,
                icon: Icons.camera_alt_outlined,
                isRaw: true,
              ),
              
              const SizedBox(width: AppDimensions.spacing16),
              
              // Orta Efekt (Sparkles)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.white,
                    size: 32,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(
                    width: 32,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.whiteOpacity(0.5),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: AppDimensions.spacing16),
              
              // Sağ Kart (AI Çekim)
              const _ImageCard(
                title: AppStrings.onboardingAiImage,
                icon: Icons.check_circle_outline,
                isRaw: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isRaw;

  const _ImageCard({
    required this.title,
    required this.icon,
    required this.isRaw,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: isRaw ? AppColors.black.withOpacity(0.4) : AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: isRaw
                ? Border.all(color: AppColors.whiteOpacity(0.2), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Image Placeholder (Gradient/Color for now)
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(isRaw ? 4.0 : 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: isRaw
                          ? BorderRadius.circular(AppDimensions.radiusMedium - 4)
                          : BorderRadius.circular(AppDimensions.radiusMedium),
                      gradient: isRaw
                          ? const LinearGradient(
                              colors: [Color(0xFF5D4037), Color(0xFF3E2723)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                    ),
                    child: Center(
                      child: isRaw
                          ? Icon(icon, color: AppColors.whiteOpacity(0.5), size: 32)
                          : null,
                    ),
                  ),
                ),
              ),
              // AI Check badge
              if (!isRaw)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.green, size: 16),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        Text(
          title,
          style: TextStyle(
            color: isRaw ? AppColors.whiteOpacity(0.7) : AppColors.white,
            fontSize: AppDimensions.fontSM,
            fontWeight: isRaw ? FontWeight.w500 : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
