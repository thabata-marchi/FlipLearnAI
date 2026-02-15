import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Use case for fetching all flashcards
class GetFlashcards extends UseCase<List<Flashcard>, NoParams> {

  /// Constructor
  GetFlashcards(this.repository);

  /// The repository to fetch flashcards from
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Fetches all saved flashcards from the repository
  @override
  Future<Either<Failure, List<Flashcard>>> call(NoParams params) {
    return repository.getAll();
  }
}
