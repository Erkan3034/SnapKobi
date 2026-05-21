import 'package:json_annotation/json_annotation.dart';
import 'package:snapkobi/domain/entities/user.dart';

import '../../domain/entities/sector.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/user.dart' as domain;

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
	final String id;
	final String email;
	final String? displayName;
	final String? avatarUrl;
	final String? phone;
	final SectorType sector;
	final domain.Language language;
	final PlanType planType;
	final int creditsLeft;
	final DateTime createdAt;
	final DateTime updatedAt;

	const UserModel({
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

	factory UserModel.fromJson(Map<String, dynamic> json) =>
			_$UserModelFromJson(json);

	Map<String, dynamic> toJson() => _$UserModelToJson(this);

	domain.User toEntity() => domain.User(
				id: id,
				email: email,
				displayName: displayName,
				avatarUrl: avatarUrl,
				phone: phone,
				sector: sector,
				language: language,
				planType: planType,
				creditsLeft: creditsLeft,
				createdAt: createdAt,
				updatedAt: updatedAt,
			);
}
