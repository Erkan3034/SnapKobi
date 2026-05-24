import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../discover_provider.dart';
import 'template_card.dart';

class PopularTemplatesSection extends StatelessWidget {
  final List<TemplateItem> items;
  const PopularTemplatesSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Row(children: [
          Text('⭐ Popüler Şablonlar', style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text('Tümünü Gör', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppDimensions.spacing8,
            mainAxisSpacing: AppDimensions.spacing8,
            childAspectRatio: 0.78,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => TemplateCard(item: items[i]),
        ),
      ),
    ]);
  }
}
