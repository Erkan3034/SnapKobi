import '../../../core/errors/app_error.dart';
import '../../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository _repository;

  const UpdatePasswordUseCase(this._repository);

  Future<Result<void>> call({required String newPassword}) {
    return _repository.updatePassword(newPassword: newPassword);
  }
}
