import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';

class UsageBanner extends ConsumerWidget {
  const UsageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final creditsLeft = user?.creditsLeft ?? 7;
    const totalCredits = 10;
    final remainingPercent = creditsLeft / totalCredits;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: remainingPercent,
                  strokeWidth: 4.5,
                  backgroundColor: AppColors.primaryLightest,
                  color: AppColors.primary,
                ),
                Text(
                  '${totalCredits - creditsLeft}/$totalCredits',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bu Ay Ücretsiz Kredi',
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$creditsLeft kredi kaldı',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pro\'ya geç',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
