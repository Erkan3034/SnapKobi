// Kütüphane şablon grid kartı.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../library_provider.dart';

class TemplateGridCard extends StatelessWidget {
  final LibraryTemplate template;
  const TemplateGridCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.templateDetail, extra: template),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(children: [
              Positioned.fill(
                child: AppNetworkImage(
                  url: template.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
                ),
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
