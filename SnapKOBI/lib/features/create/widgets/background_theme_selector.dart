import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class BackgroundThemeSelector extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeSelected;

  const BackgroundThemeSelector({super.key, required this.selectedTheme, required this.onThemeSelected});

  static const _themes = [
    ('studio', 'Stüdyo', 'https://images.unsplash.com/photo-1596265376427-4688ee0f616f?w=150&q=80'),
    ('outdoor', 'Outdoor', 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=150&q=80'),
    ('home', 'Ev', 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=150&q=80'),
    ('nature', 'Doğa', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=150&q=80'),
    ('minimalist', 'Minimalist', 'https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?w=150&q=80'),
    ('luxury', 'Lüks', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=150&q=80'),
    ('neon', 'Neon', 'https://images.unsplash.com/photo-1557682250-33bd709cbe85?w=150&q=80'),
    ('gradient', 'Gradient', 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=150&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        child: Text('Arka Plan Teması', style: AppTypography.headlineMedium.copyWith(fontSize: 16, color: AppColors.textPrimary)),
      ),
      const SizedBox(height: AppDimensions.spacing12),
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          itemCount: _themes.length,
          itemBuilder: (_, i) => _buildThemeItem(_themes[i].$1, _themes[i].$2, _themes[i].$3),
        ),
      ),
    ]);
  }

  Widget _buildThemeItem(String id, String label, String imgUrl) {
    final isSelected = selectedTheme == id;
    return GestureDetector(
      onTap: () => onThemeSelected(id),
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimensions.spacing12),
        child: Column(children: [
          Container(
            width: 68, height: 68, padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.transparent, width: 2.5),
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(12),
              child: Image.network(imgUrl, fit: BoxFit.cover)),
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(label, style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary, fontSize: 10)),
        ]),
      ),
    );
  }
}
