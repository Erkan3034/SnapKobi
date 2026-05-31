import '../../../core/errors/app_error.dart';
import '../../entities/generation.dart';
import '../../entities/platform_type.dart';
import '../../entities/sector.dart';
import '../../repositories/generation_repository.dart';

class StartGenerationUseCase {
  final GenerationRepository _repository;

  const StartGenerationUseCase(this._repository);

  Future<Result<Generation>> call({
    required String localImagePath,
    required SectorType sector,
    required PlatformType platform,
    required String backgroundTheme,
    String? templateId,
  }) {
    return _repository.startGeneration(
      localImagePath: localImagePath,
      sector: sector,
      platform: platform,
      backgroundTheme: backgroundTheme,
      templateId: templateId,
    );
  }
}
