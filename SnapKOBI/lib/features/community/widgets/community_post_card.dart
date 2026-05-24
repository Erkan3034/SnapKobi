import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../discover/discover_provider.dart';
import 'community_post_header.dart';
import 'community_post_comparison.dart';
import 'community_post_footer.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityItem item;
  const CommunityPostCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CommunityPostHeader(item: item),
          const SizedBox(height: AppDimensions.spacing12),
          CommunityPostComparison(item: item),
          const SizedBox(height: AppDimensions.spacing12),
          CommunityPostFooter(item: item),
        ],
      ),
    );
  }
}
