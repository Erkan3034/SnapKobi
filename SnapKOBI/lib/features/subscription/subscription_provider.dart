import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/subscription.dart';

class SubscriptionState {
  final PlanType currentPlan;
  final bool isYearly;
  final int creditsLeft;
  const SubscriptionState({this.currentPlan = PlanType.free, this.isYearly = false, this.creditsLeft = 7});
  SubscriptionState copyWith({bool? isYearly}) =>
      SubscriptionState(currentPlan: currentPlan, isYearly: isYearly ?? this.isYearly, creditsLeft: creditsLeft);
}

class PlanFeature {
  final String text;
  final bool included;
  const PlanFeature(this.text, {this.included = true});
}

class PlanInfo {
  final String name;
  final int priceMonthly;
  final int priceYearly;
  final List<PlanFeature> features;
  final bool isPopular;
  const PlanInfo({required this.name, required this.priceMonthly, required this.priceYearly, required this.features, this.isPopular = false});
}

const planFree = PlanInfo(name: 'Ücretsiz', priceMonthly: 0, priceYearly: 0, features: [
  PlanFeature('10 görsel/ay'), PlanFeature('Temel arka plan'), PlanFeature('Instagram metni'),
  PlanFeature('Video üretimi', included: false), PlanFeature('Öncelikli işlem', included: false),
]);

const planStarter = PlanInfo(name: 'Başlangıç', priceMonthly: 99, priceYearly: 79, isPopular: true, features: [
  PlanFeature('100 görsel/ay'), PlanFeature('Tüm arka plan temaları'), PlanFeature('5 sn tanıtım videosu'),
  PlanFeature('Tüm platform metinleri'), PlanFeature('Öncelikli işlem'),
]);

const planPro = PlanInfo(name: 'Pro', priceMonthly: 299, priceYearly: 239, features: [
  PlanFeature('Sınırsız görsel'), PlanFeature('4K kalite'), PlanFeature('API erişimi'), PlanFeature('Öncelikli destek'),
]);

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());
  void toggleBilling() => state = state.copyWith(isYearly: !state.isYearly);
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);
