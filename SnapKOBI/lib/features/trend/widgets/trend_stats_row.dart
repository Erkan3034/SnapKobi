// Trend istatistik satırı (görüntülenme/kullanım sayıları).
import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/discover_provider.dart';

class TrendStatsRow extends StatelessWidget {
  final TrendItem item;
  const TrendStatsRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      child: Row(children: [
        _chip(theme, Icons.checkroom, primary, 'Sektör: ', item.sector),
        const SizedBox(width: AppDimensions.spacing8),
        _chip(theme, Icons.trending_up, const Color(0xFF10B981), 'Popülerlik: ', item.popularity),
        const SizedBox(width: AppDimensions.spacing8),
        _chip(theme, Icons.share_outlined, primary, 'Platform: ', item.platform),
      ]),
    );
  }

  Widget _chip(ThemeData theme, IconData icon, Color color, String prefix, String val) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: theme.cardTheme.color ?? theme.cardColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      border: Border.all(color: theme.dividerColor, width: 1),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 6),
      RichText(
        text: TextSpan(
          style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color ?? theme.hintColor, fontSize: 13),
          children: [
            TextSpan(text: prefix),
            TextSpan(text: val, style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
          ],
        ),
      ),
    ]),
  );
}
