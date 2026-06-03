// Projelerim ekranı — alt menü 2. sekme; üretim geçmişi grid'i + filtre. Rota: /history
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import '../../shared/widgets/feedback/shimmer_loading.dart';
import 'history_provider.dart';
import 'widgets/history_filter_chips.dart';
import 'widgets/history_grid_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final gridDel = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, crossAxisSpacing: AppDimensions.spacing12,
      mainAxisSpacing: AppDimensions.spacing12, childAspectRatio: 0.62,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => context.push(AppRoutes.profileInfo),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.person, color: theme.colorScheme.primary, size: 20),
            ),
          ),
        ),
        title: Text('Geçmişim', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.primary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: theme.iconTheme.color),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(children: [
        const HistoryFilterChips(),
        Expanded(
          child: state.isLoading
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                  gridDelegate: gridDel,
                  itemCount: 4,
                  itemBuilder: (_, __) => const ShimmerLoading(width: double.infinity, height: double.infinity, borderRadius: 16),
                )
              : Builder(builder: (_) {
                  final items = state.visibleItems;
                  if (items.isEmpty) {
                    return Center(child: Text('Bu filtrede proje bulunmuyor.',
                        style: AppTypography.bodyMedium.copyWith(color: theme.hintColor)));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                    gridDelegate: gridDel,
                    itemCount: items.length,
                    itemBuilder: (_, i) => HistoryGridCard(item: items[i]),
                  );
                }),
        ),
      ]),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Gelişmiş Filtreleme', style: AppTypography.titleLarge.copyWith(color: Theme.of(context).textTheme.titleLarge?.color)),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(leading: const Icon(Icons.sort), title: const Text('En Yeni Önce'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.trending_up), title: const Text('En Çok Paylaşılanlar'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.star_outline), title: const Text('Yalnızca Yüksek Kaliteliler (5★)'), onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}
