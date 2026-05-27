import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import '../../shared/widgets/feedback/shimmer_loading.dart';
import '../discover/discover_provider.dart';
import 'widgets/community_category_list.dart';
import 'widgets/community_notification_helper.dart';
import 'widgets/community_post_card.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  int _selectedCatIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(discoverProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final initials = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0].toUpperCase() : 'U';
    final filtered = _getFiltered(state.community);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor, surfaceTintColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Topluluk Vitrini', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: theme.iconTheme.color), onPressed: () => showCommunityNotificationSheet(context)),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profileInfo),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing16),
              child: CircleAvatar(radius: 18, backgroundColor: AppColors.primary,
                child: Text(initials, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
      body: Column(children: [
        const SizedBox(height: AppDimensions.spacing16),
        CommunityCategoryList(onCategorySelected: (idx) => setState(() => _selectedCatIndex = idx)),
        const SizedBox(height: AppDimensions.spacing8),
        Expanded(child: state.isLoading ? _buildShimmer() : filtered.isEmpty ? _buildEmpty(theme) : ListView.builder(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
          itemCount: filtered.length,
          itemBuilder: (_, i) => CommunityPostCard(item: filtered[i]),
        )),
      ]),
    );
  }

  List<CommunityItem> _getFiltered(List<CommunityItem> all) {
    if (_selectedCatIndex == 1) return all.where((e) => (e.likesCount ?? 0) > 500).toList();
    if (_selectedCatIndex == 3) return all.where((e) => e.userName == 'butik_moda' || e.userName == 'ayakkabi_dunyasi').toList();
    if (_selectedCatIndex == 4) return all.where((e) => e.userName == 'kozmetik_dunyam').toList();
    if (_selectedCatIndex == 5) return all.where((e) => e.userName == 'lezzet_sofrasi').toList();
    if (_selectedCatIndex == 6) return all.where((e) => e.userName == 'tech_store_tr').toList();
    return all;
  }

  Widget _buildEmpty(ThemeData theme) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.feed_outlined, size: 48, color: theme.hintColor),
    const SizedBox(height: AppDimensions.spacing12),
    Text('Bu kategoride gönderi bulunmuyor.', style: AppTypography.bodyMedium.copyWith(color: theme.hintColor)),
  ]));

  Widget _buildShimmer() => ListView.builder(
    padding: const EdgeInsets.all(AppDimensions.spacing16), itemCount: 2,
    itemBuilder: (_, __) => const Padding(padding: EdgeInsets.only(bottom: AppDimensions.spacing16),
      child: ShimmerLoading(width: double.infinity, height: 240, borderRadius: AppDimensions.radiusMedium)),
  );
}
