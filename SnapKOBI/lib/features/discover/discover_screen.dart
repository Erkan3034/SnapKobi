import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import 'discover_provider.dart';
import 'widgets/community_section.dart';
import 'widgets/discover_helpers.dart';
import 'widgets/popular_templates_section.dart';
import 'widgets/quick_start_banner.dart';
import 'widgets/trending_section.dart';


// ANASAYFA - TRENDLER, SABLONLAR, TOPLULUK PAYLASIMLARI
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final initials = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0].toUpperCase() : 'U';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Row(children: [
          Text('SnapKOBİ', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.primary, fontSize: 20)),
          const SizedBox(width: 4), Icon(AppIcons.ai, color: theme.colorScheme.primary, size: 18),
        ]),
        actions: [
          IconButton(icon: Icon(AppIcons.notification, color: theme.iconTheme.color ?? theme.colorScheme.primary), onPressed: () => showNotificationSheet(context)),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profileInfo),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing16),
              child: CircleAvatar(radius: 18, backgroundColor: theme.colorScheme.primary,
                child: Text(initials, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: state.isLoading ? const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16) : EdgeInsets.zero,
        child: state.isLoading ? buildDiscoverShimmer() : Column(children: [
          QuickStartBanner(onTap: () => context.push(AppRoutes.create)),
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
}
