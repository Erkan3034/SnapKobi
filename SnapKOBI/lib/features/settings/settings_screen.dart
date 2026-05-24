import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/sector.dart';
import '../../domain/entities/subscription.dart';
import '../subscription/payment_history_screen.dart';
import '../subscription/subscription_screen.dart';
import 'screens/help_faq_screen.dart';
import 'screens/language_settings_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/profile_info_screen.dart';
import 'screens/sector_settings_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_footer.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

const _sectorLabels = {SectorType.food: 'Gıda', SectorType.textile: 'Tekstil', SectorType.electronics: 'Elektronik',
  SectorType.jewelry: 'Takı', SectorType.beauty: 'Kozmetik', SectorType.furniture: 'Mobilya', SectorType.other: 'Diğer'};
const _planLabels = {PlanType.free: 'Ücretsiz', PlanType.starter: 'Başlangıç', PlanType.pro: 'Pro', PlanType.enterprise: 'Kurumsal'};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final sector = _sectorLabels[user?.sector ?? SectorType.other] ?? 'Diğer';
    final plan = _planLabels[user?.planType ?? PlanType.free] ?? 'Ücretsiz';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(child: Column(children: [
        const ProfileHeader(),
        SettingsSection(title: 'Hesap Ayarları', children: [
          SettingsTile(icon: Icons.person_outline, title: 'Profil Bilgileri',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInfoScreen()))),
          SettingsTile(icon: Icons.grid_view, title: 'Sektör Ayarları', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            _badge(sector, AppColors.primary), const SizedBox(width: AppDimensions.spacing4),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ]), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SectorSettingsScreen()))),
          SettingsTile(icon: Icons.notifications_outlined, title: 'Bildirimler', showDivider: false,
            trailing: Switch(value: true, onChanged: (_) {}, activeThumbColor: AppColors.primary)),
        ]),
        SettingsSection(title: 'Abonelik', children: [
          SettingsTile(icon: Icons.shield_outlined, title: '$plan Plan', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Yükselt →', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))),
          SettingsTile(icon: Icons.receipt_long_outlined, title: 'Ödeme Geçmişi',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()))),
          SettingsTile(icon: Icons.settings_outlined, title: 'Abonelik Yönetimi', showDivider: false,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()))),
        ]),
        SettingsSection(title: 'Uygulama', children: [
          SettingsTile(icon: Icons.language, title: 'Dil', trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            _badge('Türkçe', AppColors.primary), const SizedBox(width: AppDimensions.spacing4),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ]), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()))),
          SettingsTile(icon: Icons.help_outline, title: 'Yardım & SSS',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpFaqScreen()))),
          SettingsTile(icon: Icons.lock_outline, title: 'Gizlilik Politikası',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()))),
          SettingsTile(icon: Icons.star_outline, title: 'Uygulamayı Puanla', showDivider: false,
            onTap: () => _showRatingDialog(context)),
        ]),
        const SettingsFooter(),
        const SizedBox(height: AppDimensions.spacing32),
      ])),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing8, vertical: AppDimensions.spacing4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
        title: const Text('Uygulamayı Puanlayın'),
        content: const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(Icons.star, color: Colors.amber, size: 36),
          Icon(Icons.star, color: Colors.amber, size: 36),
          Icon(Icons.star, color: Colors.amber, size: 36),
          Icon(Icons.star, color: Colors.amber, size: 36),
          Icon(Icons.star, color: Colors.amber, size: 36),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Puanınız için teşekkür ederiz! ⭐⭐⭐⭐⭐')));
          }, child: const Text('Gönder')),
        ],
      ),
    );
  }
}
