import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource {
  final SupabaseClient _client;

  const SupabaseAuthDataSource(this._client);

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phone,
  }) {
    final data = <String, dynamic>{};
    if (displayName != null && displayName.isNotEmpty) {
      data['full_name'] = displayName;
    }
    if (phone != null && phone.isNotEmpty) {
      data['phone'] = phone;
    }

    return _client.auth.signUp(
      email: email,
      password: password,
      data: data.isEmpty ? null : data,
    );
  }

  Future<void> signInWithGoogle({String? redirectTo}) async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  Future<void> signInWithApple({String? redirectTo}) async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: redirectTo,
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  User? getCurrentAuthUser() => _client.auth.currentUser;

  Future<void> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
  }

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }
}
