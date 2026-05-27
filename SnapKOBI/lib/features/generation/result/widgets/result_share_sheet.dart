import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';
import '../../../../core/utils/helpers/file_helper.dart';

class ResultShareSheet extends ConsumerWidget {
  const ResultShareSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge))),
      builder: (_) => const ResultShareSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(resultProvider);
    final theme = Theme.of(context);
    final channels = [
      {'name': 'Instagram', 'icon': Icons.camera_alt_outlined, 'color': const Color(0xFFE1306C)},
      {'name': 'WhatsApp', 'icon': Icons.chat_bubble_outline, 'color': const Color(0xFF25D366)},
      {'name': 'Trendyol', 'icon': Icons.shopping_bag_outlined, 'color': const Color(0xFFF27A1A)},
      {'name': 'Galeri', 'icon': Icons.download_outlined, 'color': AppColors.primary},
      {'name': 'Bağlantı', 'icon': Icons.link_outlined, 'color': AppColors.textSecondary},
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      color: theme.colorScheme.surface,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Container(width: 48, height: 5, decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(4)))),
        const SizedBox(height: AppDimensions.spacing16),
        Text('Paylaş & İndir ✨', style: AppTypography.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppDimensions.spacing12),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacing8),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          child: Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall), child: Image.network(s.processedImageUrl, width: 50, height: 50, fit: BoxFit.cover)),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Hazır Tasarım & Video', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(s.caption, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.labelSmall.copyWith(color: theme.hintColor, fontSize: 11)),
            ])),
          ]),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        SizedBox(height: 80, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: channels.length,
          itemBuilder: (context, i) {
            final ch = channels[i];
            final color = ch['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing16),
              child: GestureDetector(
                onTap: () async {
                  context.pop();
                  final name = ch['name'] as String;

                  if (name == 'Galeri') {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Expanded(child: Text('Galeriye indiriliyor...', style: TextStyle(fontSize: 14))),
                          ],
                        ),
                      ),
                    );

                    try {
                      await FileHelper.saveNetworkImageToGallery(s.processedImageUrl);
                      if (s.videoUrl != null && s.videoUrl!.isNotEmpty) {
                        await FileHelper.saveNetworkVideoToGallery(s.videoUrl!);
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tüm medya başarıyla galeriye kaydedildi! 🚀')),
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
                  } else if (name == 'Bağlantı') {
                    await Clipboard.setData(ClipboardData(text: s.processedImageUrl));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Görsel bağlantısı kopyalandı! 📋')),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Expanded(child: Text('Paylaşım hazırlanıyor...', style: TextStyle(fontSize: 14))),
                          ],
                        ),
                      ),
                    );

                    try {
                      await FileHelper.shareAll(
                        imageUrl: s.processedImageUrl,
                        caption: s.caption,
                        hashtags: s.hashtags,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Paylaşım başarısız: $e')),
                        );
                      }
                    }
                  }
                },
                child: Column(children: [
                  CircleAvatar(radius: 22, backgroundColor: color.withOpacity(0.12), child: Icon(ch['icon'] as IconData, color: color, size: 22)),
                  const SizedBox(height: 4),
                  Text(ch['name'] as String, style: AppTypography.labelSmall.copyWith(fontSize: 10, color: theme.hintColor)),
                ]),
              ),
            );
          },
        )),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium))),
          onPressed: () async {
            context.pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Expanded(child: Text('Paylaşım hazırlanıyor...', style: TextStyle(fontSize: 14))),
                  ],
                ),
              ),
            );

            try {
              await FileHelper.shareAll(
                imageUrl: s.processedImageUrl,
                caption: s.caption,
                hashtags: s.hashtags,
              );
              
              // Silently download as extra feature
              try {
                await FileHelper.saveNetworkImageToGallery(s.processedImageUrl);
                if (s.videoUrl != null && s.videoUrl!.isNotEmpty) {
                  await FileHelper.saveNetworkVideoToGallery(s.videoUrl!);
                }
              } catch (_) {}

              if (context.mounted) {
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paylaşım başarısız: $e')),
                );
              }
            }
          },
          icon: const Icon(Icons.share, size: 18),
          label: const Text('Hepsini Paketle ve Paylaş', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ]),
    );
  }
}
