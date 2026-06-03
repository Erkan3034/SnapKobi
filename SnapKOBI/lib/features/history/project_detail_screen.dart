// Tek proje detay ekranı (geçmişten açılır). Rota: /project-detail
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/helpers/file_helper.dart';
import 'history_provider.dart';
import 'widgets/project_detail_actions.dart';
import 'widgets/project_detail_caption.dart';
import 'widgets/project_detail_header.dart';
import 'widgets/project_detail_media.dart';

class ProjectDetailScreen extends StatelessWidget {
  final HistoryItem item;
  const ProjectDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: Icon(AppIcons.back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop()),
        title: Text('Proje Detayı', style: AppTypography.headlineMedium.copyWith(fontSize: 18, color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
        actions: [IconButton(icon: Icon(AppIcons.share, color: theme.iconTheme.color), onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            await FileHelper.shareAll(imageUrl: item.imageUrl, caption: item.title, hashtags: const []);
          } catch (e) {
            messenger.showSnackBar(SnackBar(content: Text('Paylaşım başarısız: $e')));
          }
        })],
      ),
      body: _Body(item: item),
    );
  }
}

class _Body extends StatelessWidget {
  final HistoryItem item;
  const _Body({required this.item});

  Widget _videoCard(BuildContext context) {
    final theme = Theme.of(context);
    final url = item.videoUrl!;
    Future<void> play() async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } catch (_) {
        messenger.showSnackBar(const SnackBar(content: Text('Video oynatılamadı.')));
      }
    }

    Future<void> download() async {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('Video indiriliyor...')));
      try {
        await FileHelper.saveNetworkVideoToGallery(url);
        messenger.showSnackBar(const SnackBar(content: Text('Video galeriye kaydedildi 🎥')));
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text('İndirme başarısız: $e')));
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('🎬 Tanıtım Videosu', style: AppTypography.titleLarge.copyWith(fontSize: 15, color: theme.textTheme.titleLarge?.color)),
        const SizedBox(height: AppDimensions.spacing12),
        GestureDetector(
          onTap: play,
          child: Container(
            height: 160,
            decoration: BoxDecoration(gradient: AppColors.splashGradient, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
            child: const Center(child: Icon(Icons.play_circle_fill, size: 56, color: AppColors.white)),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: play, icon: const Icon(Icons.play_arrow, size: 16), label: const Text('Oynat'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: OutlinedButton.icon(onPressed: download, icon: const Icon(Icons.download, size: 16), label: const Text('İndir'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)))),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppDimensions.spacing16, bottom: AppDimensions.spacing48),
        child: Column(children: [
          ProjectDetailHeader(item: item),
          ProjectDetailMedia(imageUrl: item.imageUrl, beforeUrl: item.beforeUrl),
          if (item.hasVideo) _videoCard(context),
          ProjectDetailCaption(
            platform: item.platformLabel,
            caption: item.caption.isNotEmpty ? item.caption : 'Bu proje için metin bulunmuyor.',
            hashtags: item.hashtags,
          ),
          const ProjectDetailActions(),
        ]),
    );
  }
}
