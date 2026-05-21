import '../../../core/errors/app_error.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository _repository;

  const SignInWithEmailUseCase(this._repository);

  Future<Result<User>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
