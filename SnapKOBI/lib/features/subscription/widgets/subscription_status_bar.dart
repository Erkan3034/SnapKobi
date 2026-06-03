// Mevcut abonelik durum çubuğu.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/subscription.dart';

class SubscriptionStatusBar extends ConsumerWidget {
  const SubscriptionStatusBar({super.key});

  String _planName(PlanType plan) {
    switch (plan) {
      case PlanType.free:
        return 'Ücretsiz Plan';
      case PlanType.starter:
        return 'Başlangıç Plan';
      case PlanType.pro:
        return 'Pro Plan';
      case PlanType.enterprise:
        return 'Kurumsal Plan';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final planName = _planName(user?.planType ?? PlanType.free);
    final creditsLeft = user?.creditsLeft ?? 0;
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
          'Şu an: $planName • $creditsLeft krediniz kaldı',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
