import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for GetFlashcardById use case
class GetFlashcardByIdParams {

  /// Constructor
  const GetFlashcardByIdParams({required this.flashcardId});
  /// The ID of the flashcard to retrieve
  final String flashcardId;
}

/// Use case for retrieving a single flashcard by ID
class GetFlashcardById extends UseCase<Flashcard, GetFlashcardByIdParams> {

  /// Constructor
  GetFlashcardById(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Retrieves a single flashcard from the repository by its ID
  @override
  Future<Either<Failure, Flashcard>> call(GetFlashcardByIdParams params) {
    return repository.getById(params.flashcardId);
  }
}
