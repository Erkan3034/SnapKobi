import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';
import 'subscription_provider.dart';
import 'widgets/billing_toggle.dart';
import 'widgets/plan_card_free.dart';
import 'widgets/plan_card_pro.dart';
import 'widgets/plan_card_starter.dart';
import 'widgets/subscription_status_bar.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final starterPrice = state.isYearly ? planStarter.priceYearly : planStarter.priceMonthly;
    final proPrice = state.isYearly ? planPro.priceYearly : planPro.priceMonthly;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.iconTheme.color), onPressed: () => Navigator.of(context).pop()),
        title: Text('Planınızı Seçin', style: AppTypography.headlineMedium.copyWith(color: theme.textTheme.headlineMedium?.color ?? theme.colorScheme.onSurface)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.help_outline, color: theme.iconTheme.color),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Planlar hakkında sorularınız için Ayarlar → Yardım & SSS bölümüne bakın.')),
            )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacing48),
        child: Column(children: [
          const SizedBox(height: AppDimensions.spacing12),
          const SubscriptionStatusBar(),
          const BillingToggle(),
          const PlanCardFree(price: 0),
          PlanCardStarter(price: starterPrice),
          PlanCardPro(price: proPrice),
          const SizedBox(height: AppDimensions.spacing16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.lock_outline, size: 14, color: theme.hintColor),
              const SizedBox(width: AppDimensions.spacing4),
              Text('iyzico güvenli ödeme • İstediğiniz zaman iptal',
                style: AppTypography.labelSmall.copyWith(color: theme.hintColor)),
            ]),
          ),
        ]),
      ),
    );
  }
}
