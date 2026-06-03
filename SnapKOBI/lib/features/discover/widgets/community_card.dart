import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import '../../../shared/widgets/image/before_after_slider.dart';
import '../discover_provider.dart';

class CommunityCard extends StatelessWidget {
  final CommunityItem item;
  const CommunityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item.userName ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final platform = item.platform ?? '';
    final timeAgo = item.timeAgo ?? '';
    final beforeUrl = item.beforeUrl ?? '';
    final afterUrl = item.afterUrl ?? '';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.communityDetail, extra: item),
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing4),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Text(initials, style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('@$name', style: AppTypography.labelLarge.copyWith(fontSize: 12, color: theme.textTheme.bodyLarge?.color)),
              Text('$platform · $timeAgo', style: AppTypography.labelSmall.copyWith(color: theme.hintColor, fontSize: 10)),
            ]),
          ),
        ]),
        const SizedBox(height: AppDimensions.spacing8),
        BeforeAfterSlider(beforeUrl: beforeUrl, afterUrl: afterUrl, height: 140),
      ]),
      ),
    );
  }
}
