// Trend detay ekranı (kapak + sahneler + 'bu trendi kullan'). Rota: /trend-details
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../discover/discover_provider.dart';
import 'widgets/trend_ai_scenes.dart';
import 'widgets/trend_details_bottom_bar.dart';
import 'widgets/trend_hero_card.dart';
import 'widgets/trend_ready_caption.dart';
import 'widgets/trend_stats_row.dart';

class TrendDetailsScreen extends ConsumerWidget {
  final TrendItem item;
  const TrendDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => context.pop()),
        title: Text('Trend Detayları', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trend seçenekleri yakında eklenecek.')),
          ))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: AppDimensions.spacing16),
          TrendHeroCard(item: item),
          const SizedBox(height: AppDimensions.spacing12),
          TrendStatsRow(item: item),
          const SizedBox(height: AppDimensions.spacing16),
          TrendAiScenes(item: item),
          const SizedBox(height: AppDimensions.spacing16),
          TrendReadyCaption(item: item),
        ]),
      ),
      bottomNavigationBar: const TrendDetailsBottomBar(),
    );
  }
}
