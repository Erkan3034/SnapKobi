import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/theme_provider.dart';
import '../../domain/entities/sector.dart';
import '../../domain/entities/subscription.dart';
import '../../shared/navigation/routes.dart';
import 'widgets/profile_header.dart';
import 'widgets/rating_dialog_helper.dart';
import 'widgets/settings_footer.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

const _sectorLabels = {SectorType.food: 'Gıda', SectorType.textile: 'Tekstil', SectorType.electronics: 'Elektronik',
  SectorType.jewelry: 'Takı', SectorType.beauty: 'Kozmetik', SectorType.furniture: 'Mobilya', SectorType.other: 'Diğer'};
const _planLabels = {PlanType.free: 'Ücretsiz', PlanType.starter: 'Başlangıç', PlanType.pro: 'Pro', PlanType.enterprise: 'Kurumsal'};

/// Bildirim tercihi (şimdilik oturum-içi). İleride local storage / backend'e bağlanabilir.
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final sector = _sectorLabels[user?.sector ?? SectorType.other] ?? 'Diğer';
    final plan = _planLabels[user?.planType ?? PlanType.free] ?? 'Ücretsiz';
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(child: Column(children: [
        const ProfileHeader(),
        SettingsSection(title: 'Hesap Ayarları', children: [
          SettingsTile(icon: Icons.person_outline, title: 'Profil Bilgileri', onTap: () => context.push(AppRoutes.profileInfo)),
          SettingsTile(icon: Icons.grid_view, title: 'Sektör Ayarları', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            _badge(sector, AppColors.primary), const SizedBox(width: AppDimensions.spacing4),
            Icon(Icons.chevron_right, color: theme.hintColor),
          ]), onTap: () => context.push(AppRoutes.sectorSettings)),
          SettingsTile(icon: Icons.notifications_outlined, title: 'Bildirimler', showDivider: false,
            trailing: Switch(
              value: ref.watch(notificationsEnabledProvider),
              onChanged: (val) => ref.read(notificationsEnabledProvider.notifier).state = val,
              activeThumbColor: AppColors.primary,
            )),
        ]),
        SettingsSection(title: 'Abonelik', children: [
          SettingsTile(icon: Icons.shield_outlined, title: '$plan Plan', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Yükselt →', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]), onTap: () => context.push(AppRoutes.subscription)),
          SettingsTile(icon: Icons.receipt_long_outlined, title: 'Ödeme Geçmişi', onTap: () => context.push(AppRoutes.paymentHistory)),
          SettingsTile(icon: Icons.settings_outlined, title: 'Abonelik Yönetimi', showDivider: false, onTap: () => context.push(AppRoutes.subscription)),
        ]),
        SettingsSection(title: 'Uygulama', children: [
          SettingsTile(icon: Icons.language, title: 'Dil', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            _badge('Türkçe', AppColors.primary), const SizedBox(width: AppDimensions.spacing4),
            Icon(Icons.chevron_right, color: theme.hintColor),
          ]), onTap: () => context.push(AppRoutes.languageSettings)),
          SettingsTile(icon: Icons.dark_mode_outlined, title: 'Karanlık Tema', trailing: Switch(value: isDark,
            onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(val), activeThumbColor: AppColors.primary)),
          SettingsTile(icon: Icons.help_outline, title: 'Yardım & SSS', onTap: () => context.push(AppRoutes.helpFaq)),
          SettingsTile(icon: Icons.lock_outline, title: 'Gizlilik Politikası', onTap: () => context.push(AppRoutes.privacyPolicy)),
          SettingsTile(icon: Icons.star_outline, title: 'Uygulamayı Puanla', showDivider: false, onTap: () => showRatingDialog(context)),
        ]),
        const SettingsFooter(),
        const SizedBox(height: AppDimensions.spacing32),
      ])),
    );
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
    child: Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
  );
}
