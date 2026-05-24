import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/subscription.dart';

const _planLabels = {PlanType.free: 'Ücretsiz', PlanType.starter: 'Başlangıç', PlanType.pro: 'Pro', PlanType.enterprise: 'Kurumsal'};

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final name = user?.displayName ?? 'Kullanıcı';
    final email = user?.email ?? '';
    final plan = _planLabels[user?.planType ?? PlanType.free] ?? 'Ücretsiz';
    final credits = user?.creditsLeft ?? 0;
    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: AppDimensions.spacing48, bottom: AppDimensions.spacing24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primaryDark, AppColors.primaryLight]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppDimensions.radiusLarge)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          Row(children: [
            IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.white), onPressed: () => Navigator.of(context).pop()),
            const Spacer(),
            IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.white), onPressed: () {}),
          ]),
          const SizedBox(height: AppDimensions.spacing8),
          CircleAvatar(radius: 36, backgroundColor: AppColors.white,
            child: Text(initials, style: AppTypography.headlineMedium.copyWith(color: AppColors.primary))),
          const SizedBox(height: AppDimensions.spacing12),
          Text(name, style: AppTypography.titleLarge.copyWith(color: AppColors.white)),
          const SizedBox(height: AppDimensions.spacing4),
          Text(email, style: AppTypography.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: 0.7))),
          const SizedBox(height: AppDimensions.spacing12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
            child: Text('🏆 $plan Plan • $credits kredi kaldı', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
          ),
        ]),
      ),
    );
  }
}
