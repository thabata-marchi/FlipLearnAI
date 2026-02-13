/// Failure classes for error handling across the application
abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

/// Failures related to local caching
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

/// Failures related to network operations
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

/// Failures related to AI service operations
class AIServiceFailure extends Failure {
  final String? code;

  AIServiceFailure(
    String message, {
    this.code,
  }) : super(message);
}

/// Failures related to validation
class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}

/// Generic server errors
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(
    String message, {
    this.statusCode,
  }) : super(message);
}

/// Unknown/unhandled errors
class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}
