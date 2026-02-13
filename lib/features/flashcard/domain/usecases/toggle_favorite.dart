import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for ToggleFavorite use case
class ToggleFavoriteParams {
  /// The ID of the flashcard to toggle
  final String flashcardId;

  /// Constructor
  const ToggleFavoriteParams({required this.flashcardId});
}

/// Use case for toggling the favorite status of a flashcard
class ToggleFavorite extends UseCase<Flashcard, ToggleFavoriteParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  ToggleFavorite(this.repository);

  /// Execute the use case
  ///
  /// Toggles the favorite status of the specified flashcard
  @override
  Future<Either<Failure, Flashcard>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.flashcardId);
  }
}
