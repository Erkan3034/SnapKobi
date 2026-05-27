import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/platform_type.dart';

class PlatformOptionTile extends StatelessWidget {
  final PlatformType platform;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PlatformOptionTile({
    super.key, required this.platform, required this.title, required this.description,
    required this.icon, required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing4),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLightest : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: isSelected ? AppColors.primary : theme.dividerColor, width: isSelected ? 2 : 1),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(icon, color: isSelected ? AppColors.primary : theme.hintColor, size: 22),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.titleLarge.copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(description, style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
          ])),
          Icon(isSelected ? AppIcons.statusSuccess : AppIcons.statusPending,
            color: isSelected ? AppColors.primary : AppColors.indicatorInactive, size: 24),
        ]),
      ),
    );
  }
}
