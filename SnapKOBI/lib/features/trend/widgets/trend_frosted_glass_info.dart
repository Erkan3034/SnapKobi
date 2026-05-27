import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';

class TrendFrostedGlassInfo extends StatelessWidget {
  final String usage;
  const TrendFrostedGlassInfo({super.key, required this.usage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimensions.spacing16,
      left: AppDimensions.spacing16,
      right: AppDimensions.spacing16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            color: AppColors.whiteOpacity(0.25),
            child: Row(
              children: [
                const Icon(AppIcons.ai, color: AppColors.primaryLightest, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$usage kez üretildi',
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                _buildAvatarStack(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    final avatarUrls = AppConstants.mockAvatars;
    return SizedBox(
      width: 60,
      height: 28,
      child: Stack(
        children: List.generate(avatarUrls.length, (index) {
          return Positioned(
            right: index * 14.0,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 1.5)),
              child: CircleAvatar(radius: 12, backgroundImage: NetworkImage(avatarUrls[index])),
            ),
          );
        }),
      ),
    );
  }
}
