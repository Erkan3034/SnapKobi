import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_strings.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/auth_error.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/supabase_auth_datasource.dart';
import '../datasources/remote/supabase_user_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
	final SupabaseAuthDataSource _authDs;
	final SupabaseUserDataSource _userDs;

	const AuthRepositoryImpl({
		required SupabaseAuthDataSource authDs,
		required SupabaseUserDataSource userDs,
	})  : _authDs = authDs,
				_userDs = userDs;

	@override
	Future<Result<domain.User>> signInWithEmail({
		required String email,
		required String password,
	}) async {
		try {
			final response = await _authDs.signInWithEmail(
				email: email,
				password: password,
			);

			final authUser = response.user;
			if (authUser == null) {
				return Result.failure(AuthError(message: 'Giriş başarısız.'));
			}
			final profile = await _getOrCreateProfile(authUser);
			return Result.success(profile);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<domain.User>> signUpWithEmail({
		required String email,
		required String password,
		String? displayName,
		String? phone,
	}) async {
		try {
			final response = await _authDs.signUpWithEmail(
				email: email,
				password: password,
				displayName: displayName,
				phone: phone,
			);

			final authUser = response.user;
			if (authUser == null) {
				return Result.failure(AuthError(message: 'Kayıt başarısız.'));
			}

			if (response.session == null) {
				return Result.failure(
					AuthError(
						message: AppStrings.authEmailVerificationRequired,
						code: 'EMAIL_VERIFICATION_REQUIRED',
					),
				);
			}

			final profile = await _getOrCreateProfile(
				authUser,
				displayName: displayName,
				phone: phone,
			);
			return Result.success(profile);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<void>> signInWithGoogle({String? redirectTo}) async {
		try {
			await _authDs.signInWithGoogle(redirectTo: redirectTo);
			return Result.success(null);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<void>> signInWithApple({String? redirectTo}) async {
		try {
			await _authDs.signInWithApple(redirectTo: redirectTo);
			return Result.success(null);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<void>> signOut() async {
		try {
			await _authDs.signOut();
			return Result.success(null);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<domain.User?>> getCurrentUser() async {
		try {
			final authUser = _authDs.getCurrentAuthUser();
			if (authUser == null) return Result.success(null);

			final profile = await _getOrCreateProfile(authUser);
			return Result.success(profile);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	Future<domain.User> _getOrCreateProfile(
		User authUser, {
		String? displayName,
		String? phone,
	}) async {
		final existing = await _userDs.getProfile(authUser.id);
		if (existing != null) return existing.toEntity();
		final email = authUser.email;
		if (email == null || email.isEmpty) {
			throw AuthException('Kullanici email bilgisi bulunamadi.');
		}
		final created = await _userDs.createProfile(
			userId: authUser.id,
			email: email,
			displayName: displayName ?? _readMetadata(authUser, 'full_name'),
			phone: phone ?? authUser.phone ?? _readMetadata(authUser, 'phone'),
			avatarUrl: _readMetadata(authUser, 'avatar_url'),
		);
		return created.toEntity();
	}

	String? _readMetadata(User user, String key) {
		final data = user.userMetadata;
		if (data == null) return null;
		final value = data[key];
		if (value is String && value.isNotEmpty) return value;
		return null;
	}

	@override
	Future<Result<void>> sendPasswordResetEmail({
		required String email,
		String? redirectTo,
	}) async {
		try {
			await _authDs.sendPasswordResetEmail(
				email: email,
				redirectTo: redirectTo,
			);
			return Result.success(null);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}

	@override
	Future<Result<void>> updatePassword({required String newPassword}) async {
		try {
			await _authDs.updatePassword(newPassword);
			return Result.success(null);
		} on AuthException catch (e) {
			return Result.failure(AuthError(message: e.message));
		} catch (e) {
			return Result.failure(AuthError(message: e.toString()));
		}
	}
}
