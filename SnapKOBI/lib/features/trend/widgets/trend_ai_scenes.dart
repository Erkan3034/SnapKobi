// Trend AI sahne önizlemeleri.
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../../discover/discover_provider.dart';

class TrendAiScenes extends StatelessWidget {
  final TrendItem item;
  const TrendAiScenes({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final images = item.scenes; // trends.scenes (DB)
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
        child: Text('AI Sahneleri', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final title = 'Sahne ${index + 1}';
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing12),
              child: Column(children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: AppNetworkImage(
                    url: images[index],
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                const SizedBox(height: 6),
                Text(title, style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color ?? theme.hintColor, fontSize: 11)),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}
