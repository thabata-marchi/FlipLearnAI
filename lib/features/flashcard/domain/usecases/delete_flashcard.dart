import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for DeleteFlashcard use case
class DeleteFlashcardParams {
  /// The ID of the flashcard to delete
  final String flashcardId;

  /// Constructor
  const DeleteFlashcardParams({required this.flashcardId});
}

/// Use case for deleting a flashcard
class DeleteFlashcard extends UseCase<void, DeleteFlashcardParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  DeleteFlashcard(this.repository);

  /// Execute the use case
  ///
  /// Deletes the specified flashcard from the repository
  @override
  Future<Either<Failure, void>> call(DeleteFlashcardParams params) {
    return repository.delete(params.flashcardId);
  }
}
