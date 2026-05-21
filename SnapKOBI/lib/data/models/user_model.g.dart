// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  phone: json['phone'] as String?,
  sector: $enumDecode(_$SectorTypeEnumMap, json['sector']),
  language: $enumDecode(_$LanguageEnumMap, json['language']),
  planType: $enumDecode(_$PlanTypeEnumMap, json['plan_type']),
  creditsLeft: (json['credits_left'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'phone': instance.phone,
  'sector': _$SectorTypeEnumMap[instance.sector]!,
  'language': _$LanguageEnumMap[instance.language]!,
  'plan_type': _$PlanTypeEnumMap[instance.planType]!,
  'credits_left': instance.creditsLeft,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$SectorTypeEnumMap = {
  SectorType.food: 'food',
  SectorType.textile: 'textile',
  SectorType.electronics: 'electronics',
  SectorType.jewelry: 'jewelry',
  SectorType.beauty: 'beauty',
  SectorType.furniture: 'furniture',
  SectorType.other: 'other',
};

const _$LanguageEnumMap = {
  Language.tr: 'tr',
  Language.en: 'en',
  Language.ar: 'ar',
};

const _$PlanTypeEnumMap = {
  PlanType.free: 'free',
  PlanType.starter: 'starter',
  PlanType.pro: 'pro',
  PlanType.enterprise: 'enterprise',
};
