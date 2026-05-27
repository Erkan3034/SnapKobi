import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';

class TrendDetailsBottomBar extends StatelessWidget {
  const TrendDetailsBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
              elevation: 4, shadowColor: AppColors.primary.withValues(alpha: 0.3),
            ),
            onPressed: () => context.push(AppRoutes.create),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bu Şablonu Kullan ', style: AppTypography.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.auto_awesome, color: AppColors.warning, size: 18),
              ],
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: 2, selectedItemColor: AppColors.primary, unselectedItemColor: theme.hintColor,
          type: BottomNavigationBarType.fixed, backgroundColor: theme.colorScheme.surface, elevation: 16,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Keşfet'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: 'Üretimlerim'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trendler'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
          onTap: (_) => context.pop(),
        ),
      ],
    );
  }
}
