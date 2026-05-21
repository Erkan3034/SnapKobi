import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../supabase/supabase_client.dart';
import '../errors/app_error.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../../data/datasources/remote/supabase_auth_datasource.dart';
import '../../data/datasources/remote/supabase_user_datasource.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_email_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/sign_up_with_email_usecase.dart';
import '../../domain/usecases/auth/send_password_reset_email_usecase.dart';
import '../../domain/usecases/auth/update_password_usecase.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (_) => SupabaseClientProvider.client,
);

final authInterceptorProvider = Provider<AuthInterceptor>(
  (ref) => AuthInterceptor(ref.watch(supabaseClientProvider)),
);

final dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(authInterceptor: ref.watch(authInterceptorProvider)),
);

final supabaseAuthDsProvider = Provider<SupabaseAuthDataSource>(
  (ref) => SupabaseAuthDataSource(ref.watch(supabaseClientProvider)),
);

final supabaseUserDsProvider = Provider<SupabaseUserDataSource>(
  (ref) => SupabaseUserDataSource(ref.watch(supabaseClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    authDs: ref.watch(supabaseAuthDsProvider),
    userDs: ref.watch(supabaseUserDsProvider),
  ),
);

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>(
  (ref) => SignInWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>(
  (ref) => SignUpWithEmailUseCase(ref.watch(authRepositoryProvider)),
);

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogleUseCase>(
  (ref) => SignInWithGoogleUseCase(ref.watch(authRepositoryProvider)),
);

final signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>(
  (ref) => SignInWithAppleUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);

final sendPasswordResetEmailUseCaseProvider = Provider<SendPasswordResetEmailUseCase>(
  (ref) => SendPasswordResetEmailUseCase(ref.watch(authRepositoryProvider)),
);

final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>(
  (ref) => UpdatePasswordUseCase(ref.watch(authRepositoryProvider)),
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, domain.User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<domain.User?> {
  @override
  Future<domain.User?> build() async {
    final result = await ref.read(getCurrentUserUseCaseProvider).call();
    return result.fold(
      onSuccess: (user) => user,
      onFailure: (_) => null,
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(signInWithEmailUseCaseProvider).call(
          email: email,
          password: password,
        );

    result.fold(
      onSuccess: (user) => state = AsyncData(user),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phone,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(signUpWithEmailUseCaseProvider).call(
          email: email,
          password: password,
          displayName: displayName,
          phone: phone,
        );

    result.fold(
      onSuccess: (user) => state = AsyncData(user),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final redirectTo = _getOAuthRedirectTo();
    final result = await ref
        .read(signInWithGoogleUseCaseProvider)
        .call(redirectTo: redirectTo);

    result.fold(
      onSuccess: (_) => _refreshCurrentUser(),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    final redirectTo = _getOAuthRedirectTo();
    final result = await ref
        .read(signInWithAppleUseCaseProvider)
        .call(redirectTo: redirectTo);

    result.fold(
      onSuccess: (_) => _refreshCurrentUser(),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await ref.read(signOutUseCaseProvider).call();

    result.fold(
      onSuccess: (_) => state = const AsyncData(null),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> refreshCurrentUser() async {
    await _refreshCurrentUser();
  }

  void setSignedOut() {
    state = const AsyncData(null);
  }

  Future<Result<void>> sendPasswordResetEmail({required String email}) async {
    final previousUser = state.valueOrNull;
    state = const AsyncLoading();

    final redirectTo = dotenv.env['AUTH_REDIRECT_URL'];
    final result = await ref.read(sendPasswordResetEmailUseCaseProvider).call(
          email: email,
          redirectTo: redirectTo,
        );

    result.fold(
      onSuccess: (_) => state = AsyncData(previousUser),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );

    return result;
  }

  Future<Result<void>> updatePassword({required String newPassword}) async {
    final previousUser = state.valueOrNull;
    state = const AsyncLoading();

    final result = await ref.read(updatePasswordUseCaseProvider).call(
          newPassword: newPassword,
        );

    result.fold(
      onSuccess: (_) => state = AsyncData(previousUser),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );

    return result;
  }

  Future<void> _refreshCurrentUser() async {
    final result = await ref.read(getCurrentUserUseCaseProvider).call();
    result.fold(
      onSuccess: (user) => state = AsyncData(user),
      onFailure: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  String? _getOAuthRedirectTo() {
    if (kIsWeb) return null;
    final redirectTo = dotenv.env['AUTH_REDIRECT_URL'];
    if (redirectTo == null || redirectTo.isEmpty) return null;
    return redirectTo;
  }
}
