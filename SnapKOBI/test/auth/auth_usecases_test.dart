import 'package:flutter_test/flutter_test.dart';
import 'package:snapkobi/core/errors/app_error.dart';
import 'package:snapkobi/core/errors/auth_error.dart';
import 'package:snapkobi/domain/entities/sector.dart';
import 'package:snapkobi/domain/entities/subscription.dart';
import 'package:snapkobi/domain/entities/user.dart';
import 'package:snapkobi/domain/repositories/auth_repository.dart';
import 'package:snapkobi/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/send_password_reset_email_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/sign_in_with_apple_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/sign_in_with_email_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/sign_out_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/sign_up_with_email_usecase.dart';
import 'package:snapkobi/domain/usecases/auth/update_password_usecase.dart';

class FakeAuthRepository implements AuthRepository {
  Result<User> signInWithEmailResult =
      Result.failure(const AuthError(message: 'error'));
  Result<User> signUpWithEmailResult =
      Result.failure(const AuthError(message: 'error'));
  Result<void> signInWithGoogleResult =
      Result.failure(const AuthError(message: 'error'));
  Result<void> signInWithAppleResult =
      Result.failure(const AuthError(message: 'error'));
  Result<void> signOutResult =
      Result.failure(const AuthError(message: 'error'));
  Result<User?> getCurrentUserResult =
      Result.failure(const AuthError(message: 'error'));
  Result<void> sendPasswordResetEmailResult =
      Result.failure(const AuthError(message: 'error'));
  Result<void> updatePasswordResult =
      Result.failure(const AuthError(message: 'error'));

  @override
  Future<Result<User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return signInWithEmailResult;
  }

  @override
  Future<Result<User>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phone,
  }) async {
    return signUpWithEmailResult;
  }

  @override
  Future<Result<void>> signInWithGoogle({String? redirectTo}) async {
    return signInWithGoogleResult;
  }

  @override
  Future<Result<void>> signInWithApple({String? redirectTo}) async {
    return signInWithAppleResult;
  }

  @override
  Future<Result<void>> signOut() async {
    return signOutResult;
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    return getCurrentUserResult;
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({
    required String email,
    String? redirectTo,
  }) async {
    return sendPasswordResetEmailResult;
  }

  @override
  Future<Result<void>> updatePassword({required String newPassword}) async {
    return updatePasswordResult;
  }
}

final _testUser = User(
  id: 'user-1',
  email: 'test@snapkobi.com',
  displayName: 'Test User',
  avatarUrl: null,
  phone: null,
  sector: SectorType.other,
  language: Language.tr,
  planType: PlanType.free,
  creditsLeft: 5,
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 1, 1),
);

void main() {
  group('SignInWithEmailUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..signInWithEmailResult = Result.success(_testUser);
      final usecase = SignInWithEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com', password: '123456');
      expect(result, isA<Success<User>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..signInWithEmailResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SignInWithEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com', password: '123456');
      expect(result, isA<Failure<User>>());
    });
  });

  group('SignUpWithEmailUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..signUpWithEmailResult = Result.success(_testUser);
      final usecase = SignUpWithEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com', password: '123456');
      expect(result, isA<Success<User>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..signUpWithEmailResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SignUpWithEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com', password: '123456');
      expect(result, isA<Failure<User>>());
    });
  });

  group('SignInWithGoogleUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..signInWithGoogleResult = Result.success(null);
      final usecase = SignInWithGoogleUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Success<void>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..signInWithGoogleResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SignInWithGoogleUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Failure<void>>());
    });
  });

  group('SignInWithAppleUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..signInWithAppleResult = Result.success(null);
      final usecase = SignInWithAppleUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Success<void>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..signInWithAppleResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SignInWithAppleUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Failure<void>>());
    });
  });

  group('SignOutUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()..signOutResult = Result.success(null);
      final usecase = SignOutUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Success<void>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..signOutResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SignOutUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Failure<void>>());
    });
  });

  group('GetCurrentUserUseCase', () {
    test('returns user', () async {
      final repo = FakeAuthRepository()
        ..getCurrentUserResult = Result.success(_testUser);
      final usecase = GetCurrentUserUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Success<User?>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..getCurrentUserResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = GetCurrentUserUseCase(repo);

      final result = await usecase.call();
      expect(result, isA<Failure<User?>>());
    });
  });

  group('SendPasswordResetEmailUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..sendPasswordResetEmailResult = Result.success(null);
      final usecase = SendPasswordResetEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com');
      expect(result, isA<Success<void>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..sendPasswordResetEmailResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = SendPasswordResetEmailUseCase(repo);

      final result = await usecase.call(email: 'a@b.com');
      expect(result, isA<Failure<void>>());
    });
  });

  group('UpdatePasswordUseCase', () {
    test('returns success', () async {
      final repo = FakeAuthRepository()
        ..updatePasswordResult = Result.success(null);
      final usecase = UpdatePasswordUseCase(repo);

      final result = await usecase.call(newPassword: '123456');
      expect(result, isA<Success<void>>());
    });

    test('returns failure', () async {
      final repo = FakeAuthRepository()
        ..updatePasswordResult = Result.failure(const AuthError(message: 'fail'));
      final usecase = UpdatePasswordUseCase(repo);

      final result = await usecase.call(newPassword: '123456');
      expect(result, isA<Failure<void>>());
    });
  });
}
