import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../create/create_screen.dart';
import '../settings/screens/profile_info_screen.dart';
import 'discover_provider.dart';
import 'widgets/community_section.dart';
import 'widgets/popular_templates_section.dart';
import 'widgets/quick_start_banner.dart';
import 'widgets/trending_section.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final initials = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        title: Row(children: [
          Text('SnapKOBİ', style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontSize: 20)),
          const SizedBox(width: 4), const Icon(AppIcons.ai, color: AppColors.primary, size: 18),
        ]),
        actions: [
          IconButton(icon: const Icon(AppIcons.notification, color: AppColors.primaryDark),
            onPressed: () => _showNotificationSheet(context)),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInfoScreen())),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing16),
              child: CircleAvatar(radius: 18, backgroundColor: AppColors.primary,
                child: Text(initials, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          QuickStartBanner(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateScreen()))),
          TrendingSection(items: state.trends),
          const SizedBox(height: AppDimensions.spacing16),
          PopularTemplatesSection(items: state.templates),
          const SizedBox(height: AppDimensions.spacing16),
          CommunitySection(items: state.community),
          const SizedBox(height: AppDimensions.spacing48 * 2),
        ]),
      ),
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Bildirimler 🔔', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(leading: const Icon(Icons.star, color: AppColors.warning),
            title: const Text('Tebrikler! Yapay Zeka görseliniz hazırlandı.'), subtitle: const Text('2 dakika önce')),
          ListTile(leading: const Icon(Icons.celebration, color: AppColors.primary),
            title: const Text('Yeni trend şablonlar eklendi! Hemen dene.'), subtitle: const Text('1 saat önce')),
        ]),
      ),
    );
  }
}
