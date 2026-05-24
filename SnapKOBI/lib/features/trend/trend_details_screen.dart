import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../create/create_screen.dart';
import '../discover/discover_provider.dart';
import 'widgets/trend_hero_card.dart';
import 'widgets/trend_stats_row.dart';
import 'widgets/trend_ai_scenes.dart';
import 'widgets/trend_ready_caption.dart';

class TrendDetailsScreen extends ConsumerWidget {
  final TrendItem item;

  const TrendDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.spacing16),
            TrendHeroCard(item: item),
            const SizedBox(height: AppDimensions.spacing12),
            TrendStatsRow(item: item),
            const SizedBox(height: AppDimensions.spacing16),
            TrendAiScenes(item: item),
            const SizedBox(height: AppDimensions.spacing16),
            TrendReadyCaption(item: item),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomArea(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Trend Detayları',
        style: AppTypography.headlineMedium.copyWith(
          color: AppColors.primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.primaryDark),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBottomArea(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing8,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.3),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bu Şablonu Kullan ',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.auto_awesome, color: AppColors.warning, size: 18),
              ],
            ),
          ),
        ),
        BottomNavigationBar(
          currentIndex: 2, // 'Trendler' is index 2
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          elevation: 16,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Keşfet'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: 'Üretimlerim'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trendler'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
          onTap: (index) {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
