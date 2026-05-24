import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';

/// Uygulama içi bildirim kartı — "Ürününüz Hazır!" tasarımı.
/// Kullanım: NotificationCard(title: '...', body: '...', onView: ..., onShare: ...)
class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String? thumbnailUrl;
  final String timeAgo;
  final VoidCallback? onView;
  final VoidCallback? onShare;

  const NotificationCard({
    super.key, required this.title, required this.body,
    this.thumbnailUrl, this.timeAgo = 'az önce', this.onView, this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.modalShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(AppIcons.camera, size: 18, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacing4),
          Text('SnapKOBİ', style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary, fontSize: 13)),
          const Spacer(),
          Text(timeAgo, style: AppTypography.labelSmall.copyWith(color: AppColors.textHint)),
        ]),
        const SizedBox(height: AppDimensions.spacing8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.titleLarge.copyWith(fontSize: 15)),
            const SizedBox(height: AppDimensions.spacing4),
            Text(body, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
          ])),
          if (thumbnailUrl != null) ...[
            const SizedBox(width: AppDimensions.spacing8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              child: Image.network(thumbnailUrl!, width: 56, height: 56, fit: BoxFit.cover),
            ),
          ],
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        Row(children: [
          Expanded(child: SizedBox(height: 38, child: ElevatedButton(
            onPressed: onView,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)), elevation: 0),
            child: Text('Görüntüle', style: AppTypography.labelLarge.copyWith(color: AppColors.white, fontSize: 13)),
          ))),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(child: SizedBox(height: 38, child: OutlinedButton(
            onPressed: onShare,
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))),
            child: Text('Paylaş', style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontSize: 13)),
          ))),
        ]),
      ]),
    );
  }
}
