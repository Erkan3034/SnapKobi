import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../domain/entities/subscription.dart';
import '../../../shared/navigation/routes.dart';

class UsageBanner extends ConsumerWidget {
  const UsageBanner({super.key});

  int _planTotalCredits(PlanType plan) {
    switch (plan) {
      case PlanType.free:
        return AppConstants.freeMonthlyCredits;
      case PlanType.starter:
        return AppConstants.starterMonthlyCredits;
      case PlanType.pro:
      case PlanType.enterprise:
        return AppConstants.proMonthlyCredits;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final creditsLeft = user?.creditsLeft ?? 0;
    final totalCredits = _planTotalCredits(user?.planType ?? PlanType.free);
    final remainingPercent = totalCredits == 0 ? 0.0 : creditsLeft / totalCredits;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$creditsLeft kredi kaldı',
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.push(AppRoutes.subscription),
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
