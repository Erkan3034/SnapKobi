import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final payments = [
      _Payment('24 Mayıs 2026', 'Başlangıç Planı (Aylık)', '99 ₺', 'Başarılı'),
      _Payment('24 Nisan 2026', 'Başlangıç Planı (Aylık)', '99 ₺', 'Başarılı'),
      _Payment('24 Mart 2026', 'Başlangıç Planı (Aylık)', '99 ₺', 'Başarılı'),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface), onPressed: () => context.pop()),
        title: Text('Ödeme Geçmişi', style: AppTypography.headlineMedium.copyWith(color: theme.colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            color: theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.spacing8),
              title: Text(payment.planName, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spacing4),
                child: Text('${payment.date} • iyzico', style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(payment.amount, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: AppDimensions.spacing4),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 12),
                    const SizedBox(width: AppDimensions.spacing4),
                    Text(payment.status, style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Payment {
  final String date;
  final String planName;
  final String amount;
  final String status;
  _Payment(this.date, this.planName, this.amount, this.status);
}
