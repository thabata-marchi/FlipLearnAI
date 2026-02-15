import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for UpdateFlashcard use case
class UpdateFlashcardParams {

  /// Constructor
  const UpdateFlashcardParams({required this.flashcard});
  /// The flashcard to update
  final Flashcard flashcard;
}

/// Use case for updating an existing flashcard
class UpdateFlashcard extends UseCase<Flashcard, UpdateFlashcardParams> {

  /// Constructor
  UpdateFlashcard(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Updates an existing flashcard with the provided data
  @override
  Future<Either<Failure, Flashcard>> call(UpdateFlashcardParams params) {
    return repository.update(params.flashcard);
  }
}
