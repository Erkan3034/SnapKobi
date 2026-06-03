// Topluluk gönderisi alt kısmı (beğeni/yorum aksiyonları).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';
import '../../discover/discover_provider.dart';

class CommunityPostFooter extends StatefulWidget {
  final CommunityItem item;
  const CommunityPostFooter({super.key, required this.item});

  @override
  State<CommunityPostFooter> createState() => _CommunityPostFooterState();
}

class _CommunityPostFooterState extends State<CommunityPostFooter> {
  bool _isLiked = false;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.item.likesCount ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? AppColors.error : theme.hintColor,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
              _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
            });
          },
        ),
        const SizedBox(width: 4),
        Text(
          '$_likesCount',
          style: AppTypography.labelSmall.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.chat_bubble_outline, color: theme.hintColor, size: 20),
        const SizedBox(width: 4),
        Text(
          '${widget.item.commentsCount ?? 0}',
          style: AppTypography.labelSmall.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLightest,
            foregroundColor: AppColors.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
          ),
          onPressed: () => context.push(AppRoutes.create),
          icon: const Icon(Icons.auto_awesome, size: 14),
          label: Text(
            'Şablonu Dene',
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
