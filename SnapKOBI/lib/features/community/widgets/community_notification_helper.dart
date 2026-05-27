import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

void showCommunityNotificationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
    ),
    builder: (_) => Container(
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bildirimler 🔔', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.spacing16),
          const ListTile(
            leading: Icon(Icons.star, color: AppColors.warning),
            title: Text('Tebrikler! Yapay Zeka görseliniz hazırlandı.'),
            subtitle: Text('2 dakika önce'),
          ),
        ],
      ),
    ),
  );
}
