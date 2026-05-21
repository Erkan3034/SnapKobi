import 'package:equatable/equatable.dart';

enum PlanType { free, starter, pro, enterprise }

enum SubStatus { active, pastDue, cancelled, trialing }

class Subscription extends Equatable {
	final String id;
	final String userId;
	final PlanType planType;
	final SubStatus status;
	final DateTime currentPeriodStart;
	final DateTime currentPeriodEnd;
	final bool cancelAtPeriodEnd;

	const Subscription({
		required this.id,
		required this.userId,
		required this.planType,
		required this.status,
		required this.currentPeriodStart,
		required this.currentPeriodEnd,
		required this.cancelAtPeriodEnd,
	});

	@override
	List<Object?> get props => [
				id,
				userId,
				planType,
				status,
				currentPeriodStart,
				currentPeriodEnd,
				cancelAtPeriodEnd,
			];
}
