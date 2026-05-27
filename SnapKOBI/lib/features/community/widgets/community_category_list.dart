import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'dashed_circle_painter.dart';

class CommunityCategoryList extends StatefulWidget {
  final ValueChanged<int> onCategorySelected;
  const CommunityCategoryList({super.key, required this.onCategorySelected});

  @override
  State<CommunityCategoryList> createState() => _CommunityCategoryListState();
}

class _CommunityCategoryListState extends State<CommunityCategoryList> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _categories = const [
    {'name': 'Tümü', 'image': ''},
    {'name': 'Popüler', 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=120&q=80'},
    {'name': 'Yeni', 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=120&q=80'},
    {'name': 'Moda', 'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=120&q=80'},
    {'name': 'Kozmetik', 'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=120&q=80'},
    {'name': 'Gıda', 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=120&q=80'},
    {'name': 'Teknoloji', 'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=120&q=80'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedIndex == index;
          final isTumu = index == 0;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onCategorySelected(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryLightest : AppColors.transparent,
                    border: isSelected && !isTumu ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: isTumu
                      ? CustomPaint(
                          painter: DashedCirclePainter(color: isSelected ? AppColors.primary : theme.hintColor),
                          child: Center(child: Icon(Icons.star, color: isSelected ? AppColors.primary : theme.hintColor, size: 24)),
                        )
                      : Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            category['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primaryLightest,
                              child: const Icon(Icons.image, color: AppColors.primary),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  category['name']!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? AppColors.primary : theme.hintColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
