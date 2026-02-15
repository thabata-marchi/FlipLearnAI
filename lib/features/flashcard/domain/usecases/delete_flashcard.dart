import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for DeleteFlashcard use case
class DeleteFlashcardParams {

  /// Constructor
  const DeleteFlashcardParams({required this.flashcardId});
  /// The ID of the flashcard to delete
  final String flashcardId;
}

/// Use case for deleting a flashcard
class DeleteFlashcard extends UseCase<void, DeleteFlashcardParams> {

  /// Constructor
  DeleteFlashcard(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Deletes the specified flashcard from the repository
  @override
  Future<Either<Failure, void>> call(DeleteFlashcardParams params) {
    return repository.delete(params.flashcardId);
  }
}
