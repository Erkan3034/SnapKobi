import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../discover_provider.dart';

class TemplateCard extends StatelessWidget {
  final TemplateItem item;
  final VoidCallback? onTap;
  const TemplateCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
            child: Image.network(item.imageUrl, height: 90, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, style: AppTypography.labelLarge.copyWith(fontSize: 12, color: theme.textTheme.bodyLarge?.color), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('${item.usageCount} kullanım', style: AppTypography.labelSmall.copyWith(color: theme.hintColor, fontSize: 10)),
            ]),
          ),
        ]),
      ),
    );
  }
}
