import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../settings/screens/profile_info_screen.dart';
import 'history_provider.dart';
import 'widgets/history_filter_chips.dart';
import 'widgets/history_grid_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInfoScreen())),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            child: CircleAvatar(backgroundColor: AppColors.primaryLightest,
              child: const Icon(Icons.person, color: AppColors.primary, size: 20)),
          ),
        ),
        title: Text('Geçmişim', style: AppTypography.headlineMedium.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () => _showFilterSheet(context)),
        ],
      ),
      body: Column(children: [
        const HistoryFilterChips(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: AppDimensions.spacing12,
              mainAxisSpacing: AppDimensions.spacing12, childAspectRatio: 0.62,
            ),
            itemCount: state.items.length,
            itemBuilder: (_, i) => HistoryGridCard(item: state.items[i]),
          ),
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
          Text('Gelişmiş Filtreleme', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.spacing16),
          ListTile(leading: const Icon(Icons.sort), title: const Text('En Yeni Önce'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.trending_up), title: const Text('En Çok Paylaşılanlar'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.star_outline), title: const Text('Yalnızca Yüksek Kaliteliler (5★)'), onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}
