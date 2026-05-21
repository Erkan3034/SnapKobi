import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthInterceptor extends Interceptor {
	final SupabaseClient _client;

	AuthInterceptor(this._client);

	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
		final token = _client.auth.currentSession?.accessToken;
		if (token != null && token.isNotEmpty) {
			options.headers['Authorization'] = 'Bearer $token';
		}
		handler.next(options);
	}
}
