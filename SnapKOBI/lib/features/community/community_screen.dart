import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/navigation/routes.dart';
import '../discover/discover_provider.dart';
import 'widgets/community_category_list.dart';
import 'widgets/community_post_card.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    
    String initials = 'U';
    if (user != null) {
      final name = user.displayName;
      if (name != null && name.isNotEmpty) {
        initials = name[0].toUpperCase();
      }
    }

    final filteredItems = _getFilteredItems(state.community);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Topluluk Vitrini',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryDark),
            onPressed: () => _showNotificationSheet(context),
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profileInfo),
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacing16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.spacing16),
          CommunityCategoryList(
            onCategorySelected: (index) {
              setState(() => _selectedCategoryIndex = index);
            },
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spacing24),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return CommunityPostCard(item: filteredItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<CommunityItem> _getFilteredItems(List<CommunityItem> allItems) {
    switch (_selectedCategoryIndex) {
      case 0: // Seninle
        return allItems;
      case 1: // Popüler
        return allItems.where((item) => (item.likesCount ?? 0) > 300).toList();
      case 2: // Yeni
        return allItems.where((item) => item.platform == 'Trendyol').toList();
      case 3: // Moda
        return allItems.where((item) => item.platform == 'Mağaza' || item.userName == 'butik_moda').toList();
      default:
        return allItems;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.feed_outlined, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppDimensions.spacing12),
          Text(
            'Bu kategoride gönderi bulunmuyor.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bildirimler 🔔', style: AppTypography.titleLarge),
            const SizedBox(height: AppDimensions.spacing16),
            ListTile(
              leading: const Icon(Icons.star, color: AppColors.warning),
              title: const Text('Tebrikler! Yapay Zeka görseliniz hazırlandı.'),
              subtitle: const Text('2 dakika önce'),
            ),
            ListTile(
              leading: const Icon(Icons.celebration, color: AppColors.primary),
              title: const Text('Yeni trend şablonlar eklendi! Hemen dene.'),
              subtitle: const Text('1 saat önce'),
            ),
          ],
        ),
      ),
    );
  }
}
