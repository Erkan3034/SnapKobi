import '../../core/errors/app_error.dart';
import '../entities/generation.dart';
import '../entities/sector.dart';
import '../entities/platform_type.dart';

abstract interface class GenerationRepository {
  Future<Result<Generation>> startGeneration({
    required String localImagePath,
    required SectorType sector,
    required PlatformType platform,
    String? templateId,
  });

  Stream<Result<Generation>> monitorGeneration(String id);

  Future<Result<Generation>> getGenerationDetails(String id);

  Future<Result<List<Generation>>> getHistory();
}
