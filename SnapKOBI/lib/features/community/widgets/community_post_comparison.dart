import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/discover_provider.dart';

class CommunityPostComparison extends StatelessWidget {
  final CommunityItem item;
  const CommunityPostComparison({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final beforeUrl = item.beforeUrl ?? '';
    final afterUrl = item.afterUrl ?? '';

    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusSmall),
                      bottomLeft: Radius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        beforeUrl.isNotEmpty
                            ? Image.network(beforeUrl, fit: BoxFit.cover)
                            : Container(color: AppColors.primaryLightest, child: const Icon(Icons.image, color: AppColors.primary)),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ÖNCE',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppDimensions.radiusSmall),
                      bottomRight: Radius.circular(AppDimensions.radiusSmall),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        afterUrl.isNotEmpty
                            ? Image.network(afterUrl, fit: BoxFit.cover)
                            : Container(color: AppColors.primaryLightest, child: const Icon(Icons.image, color: AppColors.primary)),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'SONRA',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
