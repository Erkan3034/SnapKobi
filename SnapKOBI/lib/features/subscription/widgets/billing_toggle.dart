import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class BillingToggle extends ConsumerWidget {
  const BillingToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isYearly = ref.watch(subscriptionProvider).isYearly;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing12),
      child: Row(children: [
        Text('Aylık', style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600, color: isYearly ? AppColors.textHint : AppColors.textPrimary,
        )),
        const SizedBox(width: AppDimensions.spacing8),
        Switch(
          value: isYearly,
          onChanged: (_) => ref.read(subscriptionProvider.notifier).toggleBilling(),
          activeThumbColor: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12, vertical: AppDimensions.spacing4),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text('Yıllık %20 İndirim', style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold, color: AppColors.warning,
          )),
        ),
      ]),
    );
  }
}
