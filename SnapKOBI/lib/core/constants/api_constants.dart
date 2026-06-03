import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiConstants {
	static const String _baseUrlProd = 'https://api.snapkobi.com/v1';
	static const String _baseUrlDev = 'http://localhost:3000/v1';
	static const String _baseUrlAndroidEmulator = 'http://10.0.2.2:3000/v1';

	// APK/release dahil her ortamda calisir. Oncelik sirasi:
	//   1) --dart-define=BACKEND_URL=...  (derleme zamani, release-guvenli)
	//   2) gomulu .env'deki BACKEND_URL   (.env pubspec asset oldugu icin APK'da da okunur)
	//   3) platform varsayilanlari        (yalnizca debug/gelistirme)
	// Gercek telefonda 'localhost'/'10.0.2.2' erisilemez; APK build'inde BACKEND_URL
	// mutlaka public HTTPS backend adresine (orn. Railway) ayarlanmalidir.
	static const String _compileTimeBackendUrl = String.fromEnvironment('BACKEND_URL');

	static String get baseUrl {
		if (_compileTimeBackendUrl.isNotEmpty) return _compileTimeBackendUrl;

		final override = dotenv.isInitialized ? dotenv.env['BACKEND_URL'] : null;
		if (override != null && override.isNotEmpty) return override;

		if (kReleaseMode) return _baseUrlProd;
		if (kIsWeb) return _baseUrlDev;
		if (Platform.isAndroid) return _baseUrlAndroidEmulator;

		return _baseUrlDev;
	}

	static const Duration connectTimeout = Duration(seconds: 10);
	static const Duration receiveTimeout = Duration(seconds: 60);

	static const String generations = '/generations';
	static const String mediaUploadUrl = '/media/upload-url';
	static const String usersMe = '/users/me';
	static const String brandKit = '/brand-kit';
	static const String products = '/products';
	static const String subscriptionsMe = '/subscriptions/me';
	static const String paymentIntent = '/payments/intent';

	static const int defaultPageSize = 20;
	static const int maxRetryAttempts = 3;
}
