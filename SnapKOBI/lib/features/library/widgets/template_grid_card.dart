import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../library_provider.dart';
import '../template_detail_screen.dart';

class TemplateGridCard extends StatelessWidget {
  final LibraryTemplate template;
  const TemplateGridCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TemplateDetailScreen(template: template)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
                child: Image.network(template.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
              ),
              if (template.isPremium)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.warning, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
                    child: Text(
                      'PRO',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(template.title, style: AppTypography.labelLarge.copyWith(fontSize: 13, color: theme.textTheme.bodyLarge?.color), maxLines: 1),
              const SizedBox(height: 2),
              Text(
                '${template.usageCount} kullanım',
                style: AppTypography.labelSmall.copyWith(color: theme.hintColor, fontSize: 10),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
