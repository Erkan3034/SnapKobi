import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/platform_type.dart';
import 'platform_option_tile.dart';

class PlatformSelectionSheet extends StatefulWidget {
  final PlatformType initialPlatform;
  final ValueChanged<PlatformType> onConfirm;
  const PlatformSelectionSheet({super.key, required this.initialPlatform, required this.onConfirm});

  @override
  State<PlatformSelectionSheet> createState() => _PlatformSelectionSheetState();

  static void show(BuildContext context, {required PlatformType current, required ValueChanged<PlatformType> onConfirm}) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: AppColors.transparent,
      builder: (_) => PlatformSelectionSheet(initialPlatform: current, onConfirm: onConfirm),
    );
  }
}

class _PlatformSelectionSheetState extends State<PlatformSelectionSheet> {
  late PlatformType _selected = widget.initialPlatform;

  static const _options = [
    (PlatformType.instagram, 'Instagram', 'Kare 1080×1080 • Emoji + Hashtag • 150 karakter', AppIcons.platformInstagram),
    (PlatformType.trendyol, 'Trendyol', 'Ürün fotoğrafı 1000×1000 • SEO başlık • 500 karakter', AppIcons.platformTrendyol),
    (PlatformType.whatsapp, 'WhatsApp Business', 'Landscape 1280×720 • Kısa satış metni • Fiyat şablonu', AppIcons.platformWhatsapp),
    (PlatformType.web, 'Web Sitesi / E-ticaret', 'Yatay banner 1200×628 • Uzun açıklama • Alt metin dahil', AppIcons.platformWeb),
    (PlatformType.tiktok, 'TikTok / Reels', 'Dikey 1080×1920 • Dikkat çekici kısa metin', AppIcons.platformTiktok),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      child: SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: AppDimensions.spacing8),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.indicatorInactive, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: AppDimensions.spacing20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Platform & Format Seçin', style: AppTypography.headlineMedium),
            const SizedBox(height: AppDimensions.spacing4),
            Text('Her platform için AI farklı format üretir', style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint)),
          ]),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        ..._options.map((o) => PlatformOptionTile(
          platform: o.$1, title: o.$2, description: o.$3, icon: o.$4,
          isSelected: _selected == o.$1, onTap: () => setState(() => _selected = o.$1),
        )),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: SizedBox(width: double.infinity, height: AppDimensions.buttonHeight, child: ElevatedButton(
            onPressed: () { widget.onConfirm(_selected); Navigator.of(context).pop(); },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: AppColors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            ),
            child: Text('Seçimi Onayla →', style: AppTypography.labelLarge.copyWith(color: AppColors.white)),
          )),
        ),
      ])),
    );
  }
}
