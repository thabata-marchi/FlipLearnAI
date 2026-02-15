import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for CreateFlashcard use case
class CreateFlashcardParams {

  /// Constructor
  const CreateFlashcardParams({required this.flashcard});
  /// The flashcard to create
  final Flashcard flashcard;
}

/// Use case for creating a new flashcard
class CreateFlashcard extends UseCase<Flashcard, CreateFlashcardParams> {

  /// Constructor
  CreateFlashcard(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Creates a new flashcard with the provided data
  @override
  Future<Either<Failure, Flashcard>> call(CreateFlashcardParams params) {
    return repository.create(params.flashcard);
  }
}
