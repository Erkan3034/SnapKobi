import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class ProfileInfoScreen extends ConsumerWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final nameCtrl = TextEditingController(text: user?.displayName ?? 'Mehmet Yılmaz');
    final emailCtrl = TextEditingController(text: user?.email ?? 'mehmet@example.com');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '+90 555 123 4567');

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.pop()),
        title: Text('Profil Bilgileri', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: CircleAvatar(
              radius: 50, backgroundColor: AppColors.primary,
              child: Text(user?.displayName?.substring(0, 2).toUpperCase() ?? 'MY',
                style: AppTypography.displayMedium.copyWith(color: AppColors.white)),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          _inputField('Ad Soyad', nameCtrl, Icons.person_outline),
          const SizedBox(height: AppDimensions.spacing16),
          _inputField('E-posta Adresi', emailCtrl, Icons.email_outlined, enabled: false),
          const SizedBox(height: AppDimensions.spacing16),
          _inputField('Telefon Numarası', phoneCtrl, Icons.phone_outlined),
          const SizedBox(height: AppDimensions.spacing32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil bilgileri güncellendi!')));
              context.pop();
            },
            child: Text('Kaydet', style: AppTypography.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      const SizedBox(height: AppDimensions.spacing8),
      TextField(
        controller: controller, enabled: enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.textHint), filled: true, fillColor: enabled ? AppColors.white : AppColors.borderLight,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall), borderSide: const BorderSide(color: AppColors.borderLight)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall), borderSide: const BorderSide(color: AppColors.borderLight)),
        ),
      ),
    ]);
  }
}
