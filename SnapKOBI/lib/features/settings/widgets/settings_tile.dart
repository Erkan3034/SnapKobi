import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 22),
        title: Text(title, style: AppTypography.bodyLarge),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textHint),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        dense: true,
      ),
      if (showDivider)
        const Divider(height: 1, indent: AppDimensions.spacing48, endIndent: AppDimensions.spacing16, color: AppColors.borderLight),
    ]);
  }
}
