import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/helpers/file_helper.dart';
import '../../../shared/navigation/routes.dart';
import '../../../shared/widgets/image/app_network_image.dart';
import '../history_provider.dart';

class HistoryGridCard extends StatelessWidget {
  final HistoryItem item;
  const HistoryGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.projectDetail, extra: item),
      child: Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: AppNetworkImage(
            url: item.imageUrl,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusMedium)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppDimensions.spacing8, AppDimensions.spacing8, AppDimensions.spacing8, 0),
          child: Text(item.title, style: AppTypography.titleLarge.copyWith(fontSize: 14, color: theme.textTheme.titleLarge?.color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4, vertical: 2),
              decoration: BoxDecoration(
                color: item.platformLabel == 'IG' ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.secondary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDimensions.spacing4),
              ),
              child: Text(item.platformLabel, style: AppTypography.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.bold, color: item.platformLabel == 'IG' ? theme.colorScheme.primary : theme.colorScheme.secondary)),
            ),
            const SizedBox(width: AppDimensions.spacing4),
            Expanded(child: Text(item.timeAgo, style: AppTypography.labelSmall.copyWith(color: theme.hintColor), overflow: TextOverflow.ellipsis)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
          child: Row(children: [
            TextButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await FileHelper.shareAll(imageUrl: item.imageUrl, caption: item.title, hashtags: const []);
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('Paylaşım başarısız: $e')));
                }
              },
              icon: Icon(Icons.ios_share, size: 14, color: theme.textTheme.bodyMedium?.color),
              label: Text('Paylaş', style: AppTypography.labelSmall.copyWith(color: theme.textTheme.bodyMedium?.color)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
            TextButton.icon(
              onPressed: () => context.push(AppRoutes.create),
              icon: Icon(Icons.bolt, size: 14, color: theme.colorScheme.primary),
              label: Text('Yeniden', style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.primary)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ]),
        ),
      ]),
    ));
  }
}
