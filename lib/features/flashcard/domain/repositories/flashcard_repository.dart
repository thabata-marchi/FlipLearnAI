import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/flashcard.dart';

/// Repository interface for flashcard data access
///
/// Defines contracts for all flashcard-related data operations.
/// Implementation is in the data layer.
abstract class FlashcardRepository {
  /// Get all flashcards
  ///
  /// Returns [Right] with list of flashcards on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<Flashcard>>> getAll();

  /// Get a single flashcard by ID
  ///
  /// Returns [Right] with the flashcard on success
  /// Returns [Left] with [Failure] if not found or error occurs
  Future<Either<Failure, Flashcard>> getById(String id);

  /// Create a new flashcard
  ///
  /// Returns [Right] with the created flashcard (with ID) on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, Flashcard>> create(Flashcard flashcard);

  /// Update an existing flashcard
  ///
  /// Returns [Right] with the updated flashcard on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, Flashcard>> update(Flashcard flashcard);

  /// Delete a flashcard by ID
  ///
  /// Returns [Right] with unit on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, void>> delete(String id);

  /// Generate a flashcard using AI from a word/phrase
  ///
  /// Takes an input word (PT or EN) and generates a complete flashcard
  /// with translation, example, and pronunciation using AI.
  ///
  /// Parameters:
  ///   - word: The input word or phrase to generate from
  ///   - aiProvider: The AI provider to use (claude or openai)
  ///   - apiKey: The API key for the AI provider
  ///
  /// Returns [Right] with the generated flashcard on success
  /// Returns [Left] with [Failure] on error (network, AI service, etc.)
  Future<Either<Failure, Flashcard>> generateWithAI({
    required String word,
    required String aiProvider,
    required String apiKey,
  });

  /// Toggle favorite status of a flashcard
  ///
  /// Returns [Right] with the updated flashcard on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, Flashcard>> toggleFavorite(String id);

  /// Search flashcards by query
  ///
  /// Searches in both front and back text
  ///
  /// Returns [Right] with matching flashcards on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<Flashcard>>> search(String query);
}
