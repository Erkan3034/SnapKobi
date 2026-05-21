import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapkobi/core/di/providers.dart';
import 'package:snapkobi/core/errors/app_error.dart';
import 'package:snapkobi/core/errors/auth_error.dart';
import 'package:snapkobi/domain/entities/user.dart';
import 'package:snapkobi/domain/entities/sector.dart';
import 'package:snapkobi/domain/entities/subscription.dart';
import 'package:snapkobi/domain/repositories/auth_repository.dart';
import 'package:snapkobi/features/home/home_screen.dart';

class FakeAuthRepository implements AuthRepository {
  Result<User> signInWithEmailResult = Result.failure(const AuthError(message: 'error'));
  Result<User> signUpWithEmailResult = Result.failure(const AuthError(message: 'error'));
  Result<void> signInWithGoogleResult = Result.failure(const AuthError(message: 'error'));
  Result<void> signInWithAppleResult = Result.failure(const AuthError(message: 'error'));
  Result<void> signOutResult = Result.failure(const AuthError(message: 'error'));
  Result<User?> getCurrentUserResult = Result.failure(const AuthError(message: 'error'));
  Result<void> sendPasswordResetEmailResult = Result.failure(const AuthError(message: 'error'));
  Result<void> updatePasswordResult = Result.failure(const AuthError(message: 'error'));

  @override
  Future<Result<User>> signInWithEmail({required String email, required String password}) async => signInWithEmailResult;

  @override
  Future<Result<User>> signUpWithEmail({required String email, required String password, String? displayName, String? phone}) async => signUpWithEmailResult;

  @override
  Future<Result<void>> signInWithGoogle({String? redirectTo}) async => signInWithGoogleResult;

  @override
  Future<Result<void>> signInWithApple({String? redirectTo}) async => signInWithAppleResult;

  @override
  Future<Result<void>> signOut() async => signOutResult;

  @override
  Future<Result<User?>> getCurrentUser() async => getCurrentUserResult;

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email, String? redirectTo}) async => sendPasswordResetEmailResult;

  @override
  Future<Result<void>> updatePassword({required String newPassword}) async => updatePasswordResult;
}

void main() {
  testWidgets('HomeScreen initial state test', (WidgetTester tester) async {
    final fakeUser = User(
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

    final fakeRepo = FakeAuthRepository()
      ..getCurrentUserResult = Result.success(fakeUser);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify app title presence
    expect(find.text('SnapKOBİ'), findsOneWidget);

    // Verify usage banner shows "5/10" (since creditsLeft is 5, 10 - 5 = 5 used)
    expect(find.text('5/10'), findsOneWidget);

    // Verify platform selector options (e.g., Trendyol)
    expect(find.textContaining('Trendyol'), findsOneWidget);
  });
}
