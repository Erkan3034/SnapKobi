// Proje detay caption bölümü.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';

class ProjectDetailCaption extends StatelessWidget {
  final String platform;
  final String caption;
  final List<String> hashtags;
  const ProjectDetailCaption({super.key, required this.platform, required this.caption, required this.hashtags});

  String get _fullText => hashtags.isEmpty ? caption : '$caption\n\n${hashtags.join(' ')}';

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _fullText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Metin panoya kopyalandı 📋')));
    }
  }

  Future<void> _edit(BuildContext context) async {
    final controller = TextEditingController(text: _fullText);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Metni Düzenle'),
        content: TextField(controller: controller, maxLines: 8, decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Kapat')),
          ElevatedButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: controller.text));
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Düzenlenen metin kopyalandı 📋')));
              }
            },
            child: const Text('Kopyala'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('📝 Platform Metni', style: AppTypography.titleLarge.copyWith(fontSize: 15, color: theme.textTheme.titleLarge?.color)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
            decoration: BoxDecoration(border: Border.all(color: primary), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            child: Text('📷 $platform', style: AppTypography.labelSmall.copyWith(color: primary, fontSize: 10)),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        Text(caption, style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color ?? theme.hintColor, height: 1.5)),
        const SizedBox(height: AppDimensions.spacing8),
        Wrap(spacing: 6, runSpacing: 4, children: hashtags.map((h) => Chip(
          label: Text(h, style: AppTypography.labelSmall.copyWith(color: primary, fontSize: 10)),
          backgroundColor: primary.withOpacity(0.1), padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
        )).toList()),
        const SizedBox(height: AppDimensions.spacing12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => _copy(context), icon: const Icon(AppIcons.copy, size: 16),
            label: const Text('Kopyala'), style: OutlinedButton.styleFrom(foregroundColor: primary,
              side: BorderSide(color: primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: OutlinedButton.icon(onPressed: () => _edit(context), icon: const Icon(AppIcons.edit, size: 16),
            label: const Text('Düzenle'), style: OutlinedButton.styleFrom(foregroundColor: primary,
              side: BorderSide(color: primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))))),
        ]),
      ]),
    );
  }
}
