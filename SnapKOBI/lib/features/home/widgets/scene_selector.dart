import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'dashed_painter.dart';

class SceneSelector extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeSelected;

  const SceneSelector({
    super.key,
    required this.selectedTheme,
    required this.onThemeSelected,
  });

  static const _scenes = [
    ('studio', 'Stüdyo', 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=150&q=80'),
    ('outdoor', 'Outdoor', 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=150&q=80'),
    ('home', 'Ev', 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=150&q=80'),
    ('nature', 'Doğa', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=150&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Text(
            'Arka Plan Teması',
            style: AppTypography.headlineMedium.copyWith(fontSize: 16, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          child: Row(
            children: [
              ..._scenes.map((scene) => _buildSceneItem(scene.$1, scene.$2, scene.$3)),
              _buildCustomItem(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSceneItem(String id, String label, String imgUrl) {
    final isSelected = selectedTheme == id;
    return GestureDetector(
      onTap: () => onThemeSelected(id),
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimensions.spacing12),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imgUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomItem() {
    final isSelected = selectedTheme == 'custom';
    return GestureDetector(
      onTap: () => onThemeSelected('custom'),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: CustomPaint(
              painter: DashedPainter(color: AppColors.primaryMid.withOpacity(0.5), radius: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLightest.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: AppColors.primaryMid),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Özel',
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
