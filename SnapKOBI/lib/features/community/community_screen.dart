// Topluluk vitrini ekranı: önce/sonra gönderilerini listeler. Rota: /community-showcase
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

// community_posts.category -> Turkce etiket
const _catLabels = {
  'fashion': 'Moda', 'textile': 'Tekstil', 'tech': 'Teknoloji', 'electronics': 'Elektronik',
  'beauty': 'Kozmetik', 'food': 'Gıda', 'jewelry': 'Takı', 'furniture': 'Mobilya', 'other': 'Diğer',
};

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  String _selectedCat = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(discoverProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final initials = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName![0].toUpperCase() : 'U';
    final categories = _buildCategories(state.community);
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
        if (!state.isLoading && categories.length > 1)
          CommunityCategoryList(
            categories: categories,
            selectedKey: _selectedCat,
            onSelected: (key) => setState(() => _selectedCat = key),
          ),
        const SizedBox(height: AppDimensions.spacing8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(discoverProvider.notifier).refresh(),
            child: state.isLoading
                ? _buildShimmer()
                : filtered.isEmpty
                    ? ListView(children: [SizedBox(height: MediaQuery.of(context).size.height * 0.3, child: _buildEmpty(theme))])
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => CommunityPostCard(item: filtered[i]),
                      ),
          ),
        ),
      ]),
    );
  }

  /// Kategori daireleri tamamen veriden turetilir: Tumu + Populer (hesaplanan)
  /// + community_posts icindeki gercek kategoriler (gorseli de gercek gonderiden).
  List<CommunityCatChip> _buildCategories(List<CommunityItem> all) {
    final chips = <CommunityCatChip>[
      const CommunityCatChip(key: 'all', label: 'Tümü', icon: Icons.star),
    ];
    if (all.any((e) => (e.likesCount ?? 0) > 500)) {
      chips.add(const CommunityCatChip(key: '__popular__', label: 'Popüler', icon: Icons.trending_up));
    }
    final seen = <String>{};
    for (final e in all) {
      final c = e.category;
      if (c == null || c.isEmpty || seen.contains(c)) continue;
      seen.add(c);
      chips.add(CommunityCatChip(key: c, label: _catLabels[c] ?? c, imageUrl: e.afterUrl));
    }
    return chips;
  }

  List<CommunityItem> _getFiltered(List<CommunityItem> all) {
    switch (_selectedCat) {
      case 'all':
        return all;
      case '__popular__':
        return all.where((e) => (e.likesCount ?? 0) > 500).toList();
      default:
        return all.where((e) => e.category == _selectedCat).toList();
    }
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
