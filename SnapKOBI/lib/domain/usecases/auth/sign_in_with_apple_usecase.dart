import '../../../core/errors/app_error.dart';
import '../../repositories/auth_repository.dart';

class SignInWithAppleUseCase {
	final AuthRepository _repository;

	const SignInWithAppleUseCase(this._repository);

	Future<Result<void>> call({String? redirectTo}) =>
			_repository.signInWithApple(redirectTo: redirectTo);
}
