/// Exception classes for error handling in data layer
abstract class AppException implements Exception {
  /// Constructor
  AppException(this.message);

  /// Error message
  final String message;

  @override
  String toString() => message;
}

/// Exceptions thrown by cache/local storage operations
class CacheException extends AppException {
  /// Constructor
  CacheException(super.message);
}

/// Exceptions thrown by network operations
class NetworkException extends AppException {
  /// Constructor
  NetworkException(super.message);
}

/// Exceptions thrown by AI service operations
class AIServiceException extends AppException {
  /// Constructor
  AIServiceException(
    super.message, {
    this.code,
  });

  /// Error code
  final String? code;
}

/// Exceptions thrown by validation failures
class ValidationException extends AppException {
  /// Constructor
  ValidationException(super.message);
}

/// Exceptions thrown by server errors
class ServerException extends AppException {
  /// Constructor
  ServerException(
    super.message, {
    this.statusCode,
  });

  /// HTTP status code
  final int? statusCode;
}

/// Generic unknown exceptions
class UnknownException extends AppException {
  /// Constructor
  UnknownException(super.message);
}
