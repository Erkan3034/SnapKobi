import 'package:flutter/material.dart';

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
        actions: [IconButton(icon: Icon(AppIcons.share, color: theme.iconTheme.color), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: AppDimensions.spacing16, bottom: AppDimensions.spacing48),
        child: Column(children: [
          ProjectDetailHeader(item: item),
          ProjectDetailMedia(imageUrl: item.imageUrl, beforeUrl: item.beforeUrl),
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
