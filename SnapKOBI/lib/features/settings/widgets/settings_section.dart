// Ayarlar başlıklı bölüm kapsayıcısı (gruplama).
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.spacing16, AppDimensions.spacing24, AppDimensions.spacing16, AppDimensions.spacing8),
        child: Text(title, style: AppTypography.labelSmall.copyWith(
          color: theme.textTheme.labelSmall?.color, fontWeight: FontWeight.w600, letterSpacing: 0.5,
        )),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(children: children),
      ),
    ]);
  }
}
