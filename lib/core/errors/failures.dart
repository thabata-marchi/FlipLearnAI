/// Failure classes for error handling across the application
abstract class Failure {
  /// Constructor
  Failure(this.message);

  /// Error message
  final String message;

  @override
  String toString() => message;
}

/// Failures related to local caching
class CacheFailure extends Failure {
  /// Constructor
  CacheFailure(super.message);
}

/// Failures related to network operations
class NetworkFailure extends Failure {
  /// Constructor
  NetworkFailure(super.message);
}

/// Failures related to AI service operations
class AIServiceFailure extends Failure {
  /// Constructor
  AIServiceFailure(
    super.message, {
    this.code,
  });

  /// Error code
  final String? code;
}

/// Failures related to validation
class ValidationFailure extends Failure {
  /// Constructor
  ValidationFailure(super.message);
}

/// Generic server errors
class ServerFailure extends Failure {
  /// Constructor
  ServerFailure(
    super.message, {
    this.statusCode,
  });

  /// HTTP status code
  final int? statusCode;
}

/// Unknown/unhandled errors
class UnknownFailure extends Failure {
  /// Constructor
  UnknownFailure(super.message);
}
