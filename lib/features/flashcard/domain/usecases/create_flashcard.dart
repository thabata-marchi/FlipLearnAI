import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for CreateFlashcard use case
class CreateFlashcardParams {
  /// The flashcard to create
  final Flashcard flashcard;

  /// Constructor
  const CreateFlashcardParams({required this.flashcard});
}

/// Use case for creating a new flashcard
class CreateFlashcard extends UseCase<Flashcard, CreateFlashcardParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  CreateFlashcard(this.repository);

  /// Execute the use case
  ///
  /// Creates a new flashcard with the provided data
  @override
  Future<Either<Failure, Flashcard>> call(CreateFlashcardParams params) {
    return repository.create(params.flashcard);
  }
}
