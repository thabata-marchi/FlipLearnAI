import 'package:dartz/dartz.dart';
import 'package:fliplearnai/core/errors/failures.dart';

/// Base class for all use cases
///
/// [ReturnType] is the return type of the use case
/// [Params] are the parameters passed to the use case
abstract class UseCase<ReturnType, Params> {
  /// Executes the use case with the given [params]
  ///
  /// Returns [Right] with the result on success
  /// Returns [Left] with a [Failure] on error
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// Parameters for use cases that don't require any parameters
class NoParams {
  /// Creates a new instance of [NoParams]
  const NoParams();
}
