import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../history/history_provider.dart';

void showCommunityNotificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
    ),
    builder: (_) => const _NotificationSheet(),
  );
}

class _NotificationSheet extends ConsumerWidget {
  const _NotificationSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Gercek bildirimler: kullanicinin tamamlanan son uretimleri.
    final recent = ref.watch(historyProvider).items.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bildirimler 🔔', style: AppTypography.titleLarge.copyWith(color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing12),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing24),
              child: Column(children: [
                Icon(Icons.notifications_none, size: 40, color: theme.hintColor),
                const SizedBox(height: AppDimensions.spacing8),
                Text('Henüz bildirim yok.', style: AppTypography.bodyMedium.copyWith(color: theme.hintColor)),
              ]),
            )
          else
            ...recent.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.hasVideo ? Icons.movie_creation : Icons.image, color: AppColors.warning),
                  title: Text('${item.title} hazır 🎉', style: theme.textTheme.bodyMedium),
                  subtitle: Text(item.timeAgo, style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
                )),
        ],
      ),
    );
  }
}
