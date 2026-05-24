import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class CommunityCategoryList extends StatefulWidget {
  final ValueChanged<int> onCategorySelected;
  const CommunityCategoryList({super.key, required this.onCategorySelected});

  @override
  State<CommunityCategoryList> createState() => _CommunityCategoryListState();
}

class _CommunityCategoryListState extends State<CommunityCategoryList> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _categories = const [
    {'name': 'Seninle', 'image': ''},
    {
      'name': 'Popüler',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=120&q=80'
    },
    {
      'name': 'Yeni',
      'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=120&q=80'
    },
    {
      'name': 'Moda',
      'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=120&q=80'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.spacing16),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedIndex == index;
          final isPlus = index == 0;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onCategorySelected(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryLightest : AppColors.transparent,
                    border: isSelected && !isPlus
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: isPlus
                      ? CustomPaint(
                          painter: DashedCirclePainter(
                            color: isSelected ? AppColors.primary : AppColors.textHint,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            category['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) => Container(
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
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
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

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashCount = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    const double doublePi = 2 * 3.141592653589793;
    final double arcLength = doublePi * radius / (dashCount * 2);
    final double dashAngle = arcLength / radius;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * 2 * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
