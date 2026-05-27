import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/navigation/routes.dart';

class SettingsFooter extends ConsumerWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      final prevUser = prev?.valueOrNull;
      final nextUser = next.valueOrNull;
      if (prevUser != null && nextUser == null) {
        if (context.mounted) context.go(AppRoutes.login);
      }
      final error = next.error;
      if (error != null && context.mounted) {
        final msg = error is AppError ? error.message : 'Bir hata oluştu.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    });

    final isLoading = ref.watch(authNotifierProvider).isLoading;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing24),
      child: Column(children: [
        TextButton(
          onPressed: isLoading ? null : () => ref.read(authNotifierProvider.notifier).signOut(),
          child: Text('Çıkış Yap', style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text('SnapKOBİ v1.0.0 • snapkobi.com', style: AppTypography.labelSmall.copyWith(color: Theme.of(context).hintColor)),
      ]),
    );
  }
}
