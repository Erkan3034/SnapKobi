// Profil bilgileri ekranı (ad/e-posta görüntüleme/düzenleme). Rota: /profile-info
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
    final nameCtrl = TextEditingController(text: user?.displayName ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Profil Bilgileri', style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: CircleAvatar(
              radius: 50, backgroundColor: theme.colorScheme.primary,
              child: Text(user?.displayName?.substring(0, 2).toUpperCase() ?? '?',
                style: AppTypography.displayMedium.copyWith(color: AppColors.white)),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          _inputField(theme, 'Ad Soyad', nameCtrl, Icons.person_outline),
          const SizedBox(height: AppDimensions.spacing16),
          _inputField(theme, 'E-posta Adresi', emailCtrl, Icons.email_outlined, enabled: false),
          const SizedBox(height: AppDimensions.spacing16),
          _inputField(theme, 'Telefon Numarası', phoneCtrl, Icons.phone_outlined),
          const SizedBox(height: AppDimensions.spacing32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil bilgileri güncellendi!')));
              context.pop();
            },
            child: Text('Kaydet', style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget _inputField(ThemeData theme, String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w600)),
      const SizedBox(height: AppDimensions.spacing8),
      TextField(
        controller: controller, enabled: enabled,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: theme.hintColor), filled: true, fillColor: enabled ? (theme.cardTheme.color ?? theme.cardColor) : theme.dividerColor.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall), borderSide: BorderSide(color: theme.dividerColor)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall), borderSide: BorderSide(color: theme.dividerColor)),
        ),
      ),
    ]);
  }
}
