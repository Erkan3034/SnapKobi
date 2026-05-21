import '../../../core/errors/app_error.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  const SignUpWithEmailUseCase(this._repository);

  Future<Result<User>> call({
    required String email,
    required String password,
    String? displayName,
    String? phone,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
      phone: phone,
    );
  }
}
