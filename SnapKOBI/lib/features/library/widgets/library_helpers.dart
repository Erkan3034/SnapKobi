import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

void showLibraryFilterSheet(BuildContext context) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Kütüphane Filtreleme', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(
            leading: const Icon(Icons.star, color: AppColors.warning),
            title: Text('Öncelikli Şablonlar (PRO)', style: theme.textTheme.bodyMedium),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.trending_up, color: theme.colorScheme.primary),
            title: Text('En Popüler Şablonlar', style: theme.textTheme.bodyMedium),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
