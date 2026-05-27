import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class SectorCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const SectorCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLightest : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 40), // Emoji boyutu
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Seçili durum tik işareti
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
