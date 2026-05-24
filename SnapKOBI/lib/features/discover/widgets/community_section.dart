import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../discover_provider.dart';
import 'community_card.dart';

class CommunitySection extends StatelessWidget {
  final List<CommunityItem> items;
  const CommunitySection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Row(children: [
          Text('💡 Topluluk Vitrini', style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text('Tümünü Gör', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
          ),
        ]),
      ),
      ...items.map((item) => CommunityCard(item: item)),
    ]);
  }
}
