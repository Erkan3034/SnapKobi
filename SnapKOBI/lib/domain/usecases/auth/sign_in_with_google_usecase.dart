import '../../../core/errors/app_error.dart';
import '../../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
	final AuthRepository _repository;

	const SignInWithGoogleUseCase(this._repository);

	Future<Result<void>> call({String? redirectTo}) =>
			_repository.signInWithGoogle(redirectTo: redirectTo);
}
