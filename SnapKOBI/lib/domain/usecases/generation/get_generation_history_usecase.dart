import '../../../core/errors/app_error.dart';
import '../../entities/generation.dart';
import '../../repositories/generation_repository.dart';

class GetGenerationHistoryUseCase {
  final GenerationRepository _repository;

  const GetGenerationHistoryUseCase(this._repository);

  Future<Result<List<Generation>>> call() {
    return _repository.getHistory();
  }
}
