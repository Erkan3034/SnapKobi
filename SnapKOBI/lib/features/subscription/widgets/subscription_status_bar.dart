import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class SubscriptionStatusBar extends ConsumerWidget {
  const SubscriptionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final planName = state.currentPlan.name == 'free' ? 'Ücretsiz Plan' : 'Başlangıç Plan';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(children: [
        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
        const SizedBox(width: AppDimensions.spacing8),
        Text(
          'Şu an: $planName • ${state.creditsLeft} krediniz kaldı',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
