import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class TrendingSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const TrendingSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Trendleri filtrele...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
          filled: true, fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }
}
