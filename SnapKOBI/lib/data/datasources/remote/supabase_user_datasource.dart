import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_constants.dart';
import '../../models/user_model.dart';
import '../../../domain/entities/sector.dart';
import '../../../domain/entities/subscription.dart';
import '../../../domain/entities/user.dart' show Language;

class SupabaseUserDataSource {
  final SupabaseClient _client;

  const SupabaseUserDataSource(this._client);

  Future<UserModel?> getProfile(String userId) async {
    final data = await _client
        .from(SupabaseConstants.usersTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel> createProfile({
    required String userId,
    required String email,
    String? displayName,
    String? phone,
    String? avatarUrl,
    SectorType sector = SectorType.other,
    Language language = Language.tr,
    PlanType planType = PlanType.free,
    int creditsLeft = 0,
  }) async {
    final now = DateTime.now().toUtc();
    final payload = <String, dynamic>{
      'id': userId,
      'email': email,
      'display_name': displayName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'sector': sector.name,
      'language': language.name,
      'plan_type': planType.name,
      'credits_left': creditsLeft,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    }..removeWhere((key, value) => value == null);

    final data = await _client
        .from(SupabaseConstants.usersTable)
        .insert(payload)
        .select()
        .single();

    return UserModel.fromJson(data);
  }
}
