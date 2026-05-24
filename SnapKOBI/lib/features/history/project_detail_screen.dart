import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(icon: const Icon(AppIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop()),
        title: Text('Proje Detayı', style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(AppIcons.share, color: AppColors.textPrimary), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppDimensions.spacing16, bottom: AppDimensions.spacing48),
        child: Column(children: [
          ProjectDetailHeader(item: item),
          ProjectDetailMedia(imageUrl: item.imageUrl),
          ProjectDetailCaption(
            platform: item.platformLabel,
            caption: 'Yeni sezon ürünlerimiz stoklarda! 👟✨ Hem şık hem konforlu tasarımıyla günlük kullanıma mükemmel uyum sağlıyor.',
            hashtags: const ['#moda', '#yenisezon', '#tarz', '#ürün'],
          ),
          const ProjectDetailActions(),
        ]),
      ),
    );
  }
}
