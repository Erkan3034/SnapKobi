import 'package:dio/dio.dart';
import '../../../core/errors/app_error.dart';
import '../../domain/entities/generation.dart';
import '../../domain/entities/platform_type.dart';
import '../../domain/entities/sector.dart';
import '../../domain/repositories/generation_repository.dart';
import '../datasources/remote/backend_generation_ds.dart';
import '../datasources/remote/supabase_generation_datasource.dart';
import '../datasources/remote/supabase_storage_datasource.dart';
import '../models/generation_model.dart';

class GenerationRepositoryImpl implements GenerationRepository {
  final SupabaseStorageDatasource _storageDs;
  final BackendGenerationDatasource _backendDs;
  final SupabaseGenerationDatasource _supabaseDs;

  const GenerationRepositoryImpl({
    required SupabaseStorageDatasource storageDs,
    required BackendGenerationDatasource backendDs,
    required SupabaseGenerationDatasource supabaseDs,
  })  : _storageDs = storageDs,
        _backendDs = backendDs,
        _supabaseDs = supabaseDs;

  @override
  Future<Result<Generation>> startGeneration({
    required String localImagePath,
    required SectorType sector,
    required PlatformType platform,
    required String backgroundTheme,
    String? templateId,
  }) async {
    try {
      // 1. Upload local file to private uploads bucket (returns relative path)
      final relativePath = await _storageDs.uploadOriginalImage(localImagePath);

      // 2. Call backend REST endpoint to initialize generation
      final result = await _backendDs.createGeneration(
        originalImagePath: relativePath,
        sector: sector.name,
        platform: platform.name,
        options: {
          'imageStyle': backgroundTheme,
          if (templateId != null) 'templateId': templateId,
        },
      );

      final generation = GenerationModel.fromJson(result).toEntity();
      return Result.success(generation);
    } on DioException catch (e) {
      return Result.failure(NetworkError(
        message: e.response?.data?['message'] ?? 'Network request failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e, stack) {
      print('❌ Error in startGeneration: $e\n$stack');
      return Result.failure(AiProcessingError(message: e.toString()));
    }
  }

  @override
  Stream<Result<Generation>> monitorGeneration(String id) {
    return _supabaseDs.listenToGeneration(id).asyncMap<Result<Generation>>((list) async {
      if (list.isEmpty) {
        return Result<Generation>.failure(const StorageError(message: 'Generation record not found'));
      }
      try {
        final rawMap = Map<String, dynamic>.from(list.first);
        final originalPath = rawMap['originalImagePath'] ?? rawMap['original_image_path'];
        if (originalPath != null && !originalPath.toString().startsWith('http')) {
          try {
            final signedUrl = await _storageDs.getSignedUrl('uploads', originalPath.toString());
            rawMap['original_image_path'] = signedUrl;
            rawMap['originalImagePath'] = signedUrl;
          } catch (_) {}
        }

        final generation = GenerationModel.fromJson(rawMap).toEntity();
        return Result<Generation>.success(generation);
      } catch (e) {
        return Result<Generation>.failure(ValidationError(e.toString()));
      }
    }).handleError((e) {
      return Result<Generation>.failure(NetworkError(message: e.toString()));
    });
  }

  @override
  Future<Result<Generation>> getGenerationDetails(String id) async {
    try {
      final result = await _backendDs.getGenerationById(id);
      final rawMap = Map<String, dynamic>.from(result);
      
      final originalPath = rawMap['originalImagePath'] ?? rawMap['original_image_path'];
      if (originalPath != null && !originalPath.toString().startsWith('http')) {
        try {
          final signedUrl = await _storageDs.getSignedUrl('uploads', originalPath.toString());
          rawMap['original_image_path'] = signedUrl;
          rawMap['originalImagePath'] = signedUrl;
        } catch (_) {}
      }

      final generation = GenerationModel.fromJson(rawMap).toEntity();
      return Result.success(generation);
    } on DioException catch (e) {
      return Result.failure(NetworkError(
        message: e.response?.data?['message'] ?? 'Network request failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e, stack) {
      print('❌ Error in getGenerationDetails: $e\n$stack');
      return Result.failure(AiProcessingError(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Generation>>> getHistory() async {
    try {
      final list = await _backendDs.getGenerations();
      final generations = <Generation>[];
      for (final item in list) {
        final rawMap = Map<String, dynamic>.from(item as Map);
        final originalPath = rawMap['originalImagePath'] ?? rawMap['original_image_path'];
        if (originalPath != null && !originalPath.toString().startsWith('http')) {
          try {
            final signedUrl = await _storageDs.getSignedUrl('uploads', originalPath.toString());
            rawMap['original_image_path'] = signedUrl;
            rawMap['originalImagePath'] = signedUrl;
          } catch (_) {}
        }
        generations.add(GenerationModel.fromJson(rawMap).toEntity());
      }
      return Result.success(generations);
    } on DioException catch (e) {
      return Result.failure(NetworkError(
        message: e.response?.data?['message'] ?? 'Network request failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e, stack) {
      print('❌ Error in getHistory: $e\n$stack');
      return Result.failure(AiProcessingError(message: e.toString()));
    }
  }
}
