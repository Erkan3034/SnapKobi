// Üretilen tanıtım videosu bölümü.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../result_provider.dart';
import '../../../../core/utils/helpers/file_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultVideoSection extends ConsumerWidget {
  const ResultVideoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(resultProvider);
    final dur = s.videoDuration;
    final theme = Theme.of(context);
    final hasVideo = s.videoUrl?.isNotEmpty ?? false;

    Future<void> playVideo() async {
      final url = s.videoUrl;
      if (url == null || url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video bağlantısı mevcut değil!')),
        );
        return;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video oynatıcı başlatılıyor... 🎬')),
      );

      final uri = Uri.parse(url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video oynatılamadı!')),
          );
        }
      }
    }

    Future<void> downloadVideo() async {
      final url = s.videoUrl;
      if (url == null || url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İndirilecek video mevcut değil!')),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('Video galeriye indiriliyor...', style: TextStyle(fontSize: 14))),
            ],
          ),
        ),
      );

      try {
        await FileHelper.saveNetworkVideoToGallery(url);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video galeriye başarıyla kaydedildi! 🎥')),
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
    }

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
            Text('Tanıtım Videosu', style: AppTypography.titleLarge),
            const Spacer(),
            if (hasVideo)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
                decoration: BoxDecoration(color: AppColors.primaryLightest, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                child: Text(dur, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              ),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          GestureDetector(
            onTap: hasVideo ? playVideo : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              child: Container(
                height: 160,
                decoration: const BoxDecoration(gradient: AppColors.splashGradient),
                child: Center(
                  child: hasVideo
                      ? const Icon(Icons.play_circle_fill, size: 56, color: AppColors.white)
                      : const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_off_outlined, size: 42, color: AppColors.white),
                            SizedBox(height: AppDimensions.spacing8),
                            Text('Video uretilemedi', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: hasVideo ? playVideo : null, child: const Text('▶ Oynat'))),
            const SizedBox(width: AppDimensions.spacing8),
            Expanded(child: OutlinedButton(onPressed: hasVideo ? downloadVideo : null, child: const Text('⬇ İndir'))),
          ]),
        ]),
      ),
    );
  }
}
