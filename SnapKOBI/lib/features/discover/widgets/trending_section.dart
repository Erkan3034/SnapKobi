import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../discover_provider.dart';
import '../../trend/trending_screen.dart';
import 'trending_card.dart';

class TrendingSection extends StatelessWidget {
  final List<TrendItem> items;
  const TrendingSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Row(children: [
          Text('🔥 Bu Hafta Trend', style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
          const Spacer(),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TrendingScreen()),
              );
            },
            child: Text('Tümünü Gör', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
          ),
        ]),
      ),
      SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          itemCount: items.length,
          itemBuilder: (_, i) => TrendingCard(item: items[i]),
        ),
      ),
    ]);
  }
}
