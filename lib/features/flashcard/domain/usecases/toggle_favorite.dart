import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for ToggleFavorite use case
class ToggleFavoriteParams {

  /// Constructor
  const ToggleFavoriteParams({required this.flashcardId});
  /// The ID of the flashcard to toggle
  final String flashcardId;
}

/// Use case for toggling the favorite status of a flashcard
class ToggleFavorite extends UseCase<Flashcard, ToggleFavoriteParams> {

  /// Constructor
  ToggleFavorite(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

  /// Execute the use case
  ///
  /// Toggles the favorite status of the specified flashcard
  @override
  Future<Either<Failure, Flashcard>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.flashcardId);
  }
}
