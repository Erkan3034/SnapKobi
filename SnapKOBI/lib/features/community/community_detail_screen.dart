import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import '../../shared/widgets/image/app_network_image.dart';
import '../../shared/widgets/image/before_after_slider.dart';
import '../../shared/widgets/image/fullscreen_image_viewer.dart';
import '../discover/discover_provider.dart';

/// Topluluk gönderisi detayı: büyük önce/sonra karşılaştırma + görsele dokununca
/// tam ekran (pinch-zoom) görüntüleyici. Tasarım uygulamanın kart/mor diliyle uyumlu.
class CommunityDetailScreen extends StatelessWidget {
  final CommunityItem item;
  const CommunityDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item.userName ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final before = item.beforeUrl ?? '';
    final after = item.afterUrl ?? '';
    final images = <({String label, String url})>[
      (label: 'Önce', url: before),
      (label: 'Sonra', url: after),
    ];

    void openFullscreen(int index) =>
        FullscreenImageViewer.show(context, images: images, initialIndex: index);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('@$name', style: AppTypography.headlineMedium.copyWith(fontSize: 18, color: theme.colorScheme.primary)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacing32),
        children: [
          // ── Kullanıcı başlığı ──
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            child: Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLightest,
                backgroundImage: (item.avatarUrl != null && item.avatarUrl!.isNotEmpty) ? NetworkImage(item.avatarUrl!) : null,
                child: (item.avatarUrl == null || item.avatarUrl!.isEmpty)
                    ? Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))
                    : null,
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('@$name', style: AppTypography.titleLarge.copyWith(fontSize: 16, color: theme.colorScheme.onSurface)),
                  Text('${item.platform ?? ''} · ${item.timeAgo ?? ''}', style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
                ]),
              ),
            ]),
          ),

          // ── Büyük önce/sonra karşılaştırma (sürüklenebilir) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: BeforeAfterSlider(beforeUrl: before, afterUrl: after, height: 360),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.spacing16, AppDimensions.spacing8, AppDimensions.spacing16, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.swipe, size: 14, color: theme.hintColor),
              const SizedBox(width: 6),
              Text('Karşılaştırmak için kaydır, büyütmek için dokun', style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
            ]),
          ),

          const SizedBox(height: AppDimensions.spacing16),

          // ── Önce / Sonra ayrı kartlar (dokununca tam ekran) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Row(children: [
              Expanded(child: _labeledImage(context, 'Önce', before, () => openFullscreen(0))),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(child: _labeledImage(context, 'Sonra', after, () => openFullscreen(1))),
            ]),
          ),

          const SizedBox(height: AppDimensions.spacing20),

          // ── İstatistikler ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Row(children: [
              Icon(Icons.favorite, color: AppColors.error, size: 20),
              const SizedBox(width: 6),
              Text('${item.likesCount ?? 0}', style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(width: AppDimensions.spacing20),
              Icon(Icons.chat_bubble_outline, color: theme.hintColor, size: 20),
              const SizedBox(width: 6),
              Text('${item.commentsCount ?? 0}', style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onSurface)),
            ]),
          ),

          const SizedBox(height: AppDimensions.spacing24),

          // ── Bu tarz üret ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
                ),
                onPressed: () => context.push(AppRoutes.create),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text('Bu Tarz Üret', style: AppTypography.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledImage(BuildContext context, String label, String url, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: theme.hintColor, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Stack(children: [
          AspectRatio(
            aspectRatio: 1,
            child: AppNetworkImage(url: url, width: double.infinity, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
          ),
          Positioned(
            right: 8, bottom: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
              child: const Icon(Icons.fullscreen, color: Colors.white, size: 16),
            ),
          ),
        ]),
      ]),
    );
  }
}
