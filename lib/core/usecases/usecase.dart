import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Base class for all use cases
///
/// [Type] is the return type of the use case
/// [Params] are the parameters passed to the use case
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given [params]
  ///
  /// Returns [Right] with the result on success
  /// Returns [Left] with a [Failure] on error
  Future<Either<Failure, Type>> call(Params params);
}

/// Parameters for use cases that don't require any parameters
class NoParams {
  const NoParams();
}
