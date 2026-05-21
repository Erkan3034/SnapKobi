import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
	final Dio _dio;

	DioClient({required AuthInterceptor authInterceptor})
			: _dio = Dio(
					BaseOptions(
						baseUrl: ApiConstants.baseUrl,
						connectTimeout: ApiConstants.connectTimeout,
						receiveTimeout: ApiConstants.receiveTimeout,
						headers: {
							'Content-Type': 'application/json',
						},
					),
				) {
		_dio.interceptors.add(authInterceptor);
	}

	Dio get dio => _dio;
}
