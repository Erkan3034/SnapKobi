import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return Column(children: [
      ListTile(
        leading: Icon(icon, color: theme.iconTheme.color, size: 22),
        title: Text(title, style: AppTypography.bodyLarge.copyWith(color: theme.textTheme.bodyLarge?.color)),
        trailing: trailing ?? Icon(Icons.chevron_right, color: theme.hintColor),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        dense: true,
      ),
      if (showDivider)
        Divider(height: 1, indent: AppDimensions.spacing48, endIndent: AppDimensions.spacing16, color: theme.dividerColor),
    ]);
  }
}
