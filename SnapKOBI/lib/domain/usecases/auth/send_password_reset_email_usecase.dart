import '../../../core/errors/app_error.dart';
import '../../repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository _repository;

  const SendPasswordResetEmailUseCase(this._repository);

  Future<Result<void>> call({
    required String email,
    String? redirectTo,
  }) {
    return _repository.sendPasswordResetEmail(
      email: email,
      redirectTo: redirectTo,
    );
  }
}
