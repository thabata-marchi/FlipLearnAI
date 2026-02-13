import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for UpdateFlashcard use case
class UpdateFlashcardParams {
  /// The flashcard to update
  final Flashcard flashcard;

  /// Constructor
  const UpdateFlashcardParams({required this.flashcard});
}

/// Use case for updating an existing flashcard
class UpdateFlashcard extends UseCase<Flashcard, UpdateFlashcardParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  UpdateFlashcard(this.repository);

  /// Execute the use case
  ///
  /// Updates an existing flashcard with the provided data
  @override
  Future<Either<Failure, Flashcard>> call(UpdateFlashcardParams params) {
    return repository.update(params.flashcard);
  }
}
