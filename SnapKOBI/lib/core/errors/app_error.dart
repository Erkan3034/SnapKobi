abstract class AppError implements Exception {
	final String message;
	final String code;

	const AppError({required this.message, required this.code});

	@override
	String toString() => message;
}

class NetworkError extends AppError {
	final int? statusCode;

	const NetworkError({
		required super.message,
		super.code = 'NETWORK_ERROR',
		this.statusCode,
	});
}

class ValidationError extends AppError {
	const ValidationError(String message)
			: super(message: message, code: 'VALIDATION_ERROR');
}

class AiProcessingError extends AppError {
	const AiProcessingError({required super.message, super.code = 'AI_ERROR'});
}

class StorageError extends AppError {
	const StorageError({required super.message, super.code = 'STORAGE_ERROR'});
}

sealed class Result<T> {
	const Result();

	factory Result.success(T data) = Success<T>;
	factory Result.failure(AppError error) = Failure<T>;

	bool get isSuccess => this is Success<T>;

	R fold<R>({
		required R Function(T) onSuccess,
		required R Function(AppError) onFailure,
	}) =>
			switch (this) {
				Success(:final data) => onSuccess(data),
				Failure(:final error) => onFailure(error),
			};
}

class Success<T> extends Result<T> {
	final T data;
	const Success(this.data);
}

class Failure<T> extends Result<T> {
	final AppError error;
	const Failure(this.error);
}
