// Pro plan kartı.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../subscription_provider.dart';

class PlanCardPro extends StatelessWidget {
  final int price;
  const PlanCardPro({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeGreen = theme.brightness == Brightness.dark ? const Color(0xFF10B981) : AppColors.success;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: const [AppShadows.cardShadow],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Pro', style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing12, vertical: AppDimensions.spacing4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.auto_awesome, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: AppDimensions.spacing4),
              Text('PRO', style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$price ₺', style: AppTypography.displayMedium.copyWith(color: theme.textTheme.displayMedium?.color)),
          Text(' / ay', style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color)),
        ]),
        const SizedBox(height: AppDimensions.spacing12),
        ...planPro.features.map((f) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
          child: Row(children: [
            Icon(Icons.check_circle, size: 18, color: activeGreen),
            const SizedBox(width: AppDimensions.spacing8),
            Text(f.text, style: AppTypography.bodyMedium.copyWith(color: theme.textTheme.bodyMedium?.color)),
          ]),
        )),
        const SizedBox(height: AppDimensions.spacing16),
        Center(
          child: TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ödeme entegrasyonu (iyzico) yakında eklenecek.')),
            ),
            child: Text("Pro'ya Geç", style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.primary)),
          ),
        ),
      ]),
    );
  }
}
