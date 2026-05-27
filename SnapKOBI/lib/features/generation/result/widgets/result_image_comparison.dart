import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/image/before_after_slider.dart';
import '../result_provider.dart';
import '../../../../core/utils/helpers/file_helper.dart';

class ResultImageComparison extends ConsumerWidget {
  const ResultImageComparison({super.key});

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
            Text('Görsel Karşılaştırma', style: AppTypography.titleLarge),
            const Spacer(),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => const AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Expanded(child: Text('Fotoğraf galeriye kaydediliyor...', style: TextStyle(fontSize: 14))),
                      ],
                    ),
                  ),
                );

                try {
                  await FileHelper.saveNetworkImageToGallery(s.processedImageUrl);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fotoğraf galeriye kaydedildi! 💾')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Hata oluştu: $e')),
                    );
                  }
                }
              },
              child: Text(
                'Kaydet 💾',
                style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
              ),
            ),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          BeforeAfterSlider(
            beforeUrl: s.originalImageUrl,
            afterUrl: s.processedImageUrl,
            height: 220,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Center(
            child: Text(
              '⭐⭐⭐⭐⭐ Yüksek Kalite',
              style: AppTypography.labelSmall.copyWith(color: theme.hintColor),
            ),
          ),
        ]),
      ),
    );
  }
}
