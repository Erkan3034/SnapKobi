// Topluluk gönderisi üst kısmı (kullanıcı/sektör bilgisi).
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/discover_provider.dart';

class CommunityPostHeader extends StatelessWidget {
  final CommunityItem item;
  const CommunityPostHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = item.avatarUrl;
    final name = item.userName ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final platform = item.platform ?? 'Instagram';
    final timeAgo = item.timeAgo ?? 'az önce';

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: avatar != null && avatar.isNotEmpty ? NetworkImage(avatar) : null,
          backgroundColor: AppColors.primaryLightest,
          child: avatar == null || avatar.isEmpty
              ? Text(
                  initials,
                  style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@$name',
                style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
              ),
              const SizedBox(height: 2),
              Text(
                '$platform · $timeAgo',
                style: AppTypography.labelSmall.copyWith(
                    color: theme.hintColor,
                  ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: theme.hintColor),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gönderi seçenekleri yakında eklenecek.')),
          ),
        ),
      ],
    );
  }
}
