/// Exception classes for error handling in data layer
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exceptions thrown by cache/local storage operations
class CacheException extends AppException {
  CacheException(String message) : super(message);
}

/// Exceptions thrown by network operations
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

/// Exceptions thrown by AI service operations
class AIServiceException extends AppException {
  final String? code;

  AIServiceException(
    String message, {
    this.code,
  }) : super(message);
}

/// Exceptions thrown by validation failures
class ValidationException extends AppException {
  ValidationException(String message) : super(message);
}

/// Exceptions thrown by server errors
class ServerException extends AppException {
  final int? statusCode;

  ServerException(
    String message, {
    this.statusCode,
  }) : super(message);
}

/// Generic unknown exceptions
class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}
