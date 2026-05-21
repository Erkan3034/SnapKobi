import 'package:flutter/foundation.dart';

abstract final class AppLogger {
	static void d(String message) {
		if (kDebugMode) {
			debugPrint('[D] $message');
		}
	}

	static void e(String message, [Object? error, StackTrace? stackTrace]) {
		if (kDebugMode) {
			debugPrint('[E] $message');
			if (error != null) debugPrint('  error: $error');
			if (stackTrace != null) debugPrint('  stack: $stackTrace');
		}
	}
}
