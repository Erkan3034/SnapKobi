import '../../../core/errors/app_error.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
	final AuthRepository _repository;

	const GetCurrentUserUseCase(this._repository);

	Future<Result<User?>> call() => _repository.getCurrentUser();
}
