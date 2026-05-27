import '../../../core/errors/app_error.dart';
import '../../entities/generation.dart';
import '../../repositories/generation_repository.dart';

class WatchGenerationUseCase {
  final GenerationRepository _repository;

  const WatchGenerationUseCase(this._repository);

  Stream<Result<Generation>> call(String generationId) {
    return _repository.monitorGeneration(generationId);
  }
}
