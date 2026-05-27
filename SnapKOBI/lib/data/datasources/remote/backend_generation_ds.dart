import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class BackendGenerationDatasource {
  final Dio _dio;

  const BackendGenerationDatasource(this._dio);

  Future<Map<String, dynamic>> createGeneration({
    required String originalImagePath,
    required String sector,
    required String platform,
    Map<String, dynamic>? options,
  }) async {
    final response = await _dio.post(
      ApiConstants.generations,
      data: {
        'originalImagePath': originalImagePath,
        'sector': sector,
        'platform': platform,
        'options': options ?? {},
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getGenerationById(String id) async {
    final response = await _dio.get('${ApiConstants.generations}/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getGenerations() async {
    final response = await _dio.get(ApiConstants.generations);
    return response.data as List<dynamic>;
  }
}
