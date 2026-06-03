// Üretilen caption/hashtag bölümü (kopyalama ile).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';

class ResultCaptionSection extends ConsumerWidget {
  const ResultCaptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(resultProvider);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('${s.platformLabel} Metni', style: AppTypography.titleLarge),
            const Spacer(),
            Chip(
              label: Text('📷 ${s.platformLabel}', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              backgroundColor: theme.colorScheme.surface,
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          Text(s.caption, style: AppTypography.bodyMedium.copyWith(color: theme.hintColor)),
          const SizedBox(height: AppDimensions.spacing8),
          Wrap(
            spacing: AppDimensions.spacing4,
            runSpacing: AppDimensions.spacing4,
            children: s.hashtags
                .map((h) => Chip(
                      label: Text(h, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                      backgroundColor: AppColors.primaryLightest,
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final fullText = '${s.caption}\n\n${s.hashtags.join(' ')}';
                  await Clipboard.setData(ClipboardData(text: fullText));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Metin panoya kopyalandı! 📋')),
                    );
                  }
                },
                child: const Text('📋 Kopyala'),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      final controller = TextEditingController(text: s.caption);
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Metni Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: TextField(
                          controller: controller,
                          maxLines: 6,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Açıklama metnini buraya yazın...',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('İptal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              ref.read(resultProvider.notifier).updateCaption(controller.text);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Metin güncellendi! ✏')),
                              );
                            },
                            child: const Text('Kaydet'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('✏ Düzenle'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
