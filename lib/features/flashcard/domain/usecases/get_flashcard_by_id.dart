import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for GetFlashcardById use case
class GetFlashcardByIdParams {
  /// The ID of the flashcard to retrieve
  final String flashcardId;

  /// Constructor
  const GetFlashcardByIdParams({required this.flashcardId});
}

/// Use case for retrieving a single flashcard by ID
class GetFlashcardById extends UseCase<Flashcard, GetFlashcardByIdParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  GetFlashcardById(this.repository);

  /// Execute the use case
  ///
  /// Retrieves a single flashcard from the repository by its ID
  @override
  Future<Either<Failure, Flashcard>> call(GetFlashcardByIdParams params) {
    return repository.getById(params.flashcardId);
  }
}
