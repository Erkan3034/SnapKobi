import '../../core/errors/app_error.dart';
import '../entities/user.dart';

abstract class AuthRepository {
	Future<Result<User>> signInWithEmail({
		required String email,
		required String password,
	});

	Future<Result<User>> signUpWithEmail({
		required String email,
		required String password,
		String? displayName,
		String? phone,
	});

	Future<Result<void>> signInWithGoogle({String? redirectTo});

	Future<Result<void>> signInWithApple({String? redirectTo});

	Future<Result<void>> signOut();

	Future<Result<User?>> getCurrentUser();

	Future<Result<void>> sendPasswordResetEmail({
		required String email,
		String? redirectTo,
	});

	Future<Result<void>> updatePassword({
		required String newPassword,
	});
}
