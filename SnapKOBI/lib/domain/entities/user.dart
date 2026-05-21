import 'package:equatable/equatable.dart';

import 'sector.dart';
import 'subscription.dart';

enum Language { tr, en, ar }

class User extends Equatable {
	final String id;
	final String email;
	final String? displayName;
	final String? avatarUrl;
	final String? phone;
	final SectorType sector;
	final Language language;
	final PlanType planType;
	final int creditsLeft;
	final DateTime createdAt;
	final DateTime updatedAt;

	const User({
		required this.id,
		required this.email,
		this.displayName,
		this.avatarUrl,
		this.phone,
		required this.sector,
		required this.language,
		required this.planType,
		required this.creditsLeft,
		required this.createdAt,
		required this.updatedAt,
	});

	@override
	List<Object?> get props => [
				id,
				email,
				displayName,
				avatarUrl,
				phone,
				sector,
				language,
				planType,
				creditsLeft,
				createdAt,
				updatedAt,
			];
}
