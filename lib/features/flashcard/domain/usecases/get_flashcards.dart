import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Use case for fetching all flashcards
class GetFlashcards extends UseCase<List<Flashcard>, NoParams> {
  final FlashcardRepository repository;

  /// Constructor
  GetFlashcards(this.repository);

  /// Execute the use case
  ///
  /// Fetches all saved flashcards from the repository
  @override
  Future<Either<Failure, List<Flashcard>>> call(NoParams params) {
    return repository.getAll();
  }
}
