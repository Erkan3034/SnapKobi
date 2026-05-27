import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/discover_provider.dart';

class TrendReadyCaption extends StatelessWidget {
  final TrendItem item;
  const TrendReadyCaption({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
        child: Text('Hazır İçerik Metni', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Text(item.caption, style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface, fontSize: 14, height: 1.4)),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.copy_outlined, color: primary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '${item.caption}\n\n${item.hashtags.join(" ")}'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text('Metin panoya kopyalandı! 📋'), backgroundColor: primary),
                );
              },
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: item.hashtags.map((tag) => Text(tag, style: AppTypography.labelSmall.copyWith(color: primary, fontWeight: FontWeight.bold, fontSize: 12))).toList(),
          ),
        ]),
      ),
    ]);
  }
}
