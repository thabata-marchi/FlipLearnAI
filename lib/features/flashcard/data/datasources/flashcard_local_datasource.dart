import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Abstract local data source for flashcard operations
///
/// Defines contracts for local storage operations using Hive
abstract class FlashcardLocalDataSource {
  /// Get all saved flashcards
  ///
  /// Throws [Exception] if operation fails
  Future<List<FlashcardModel>> getFlashcards();

  /// Get a single flashcard by ID
  ///
  /// Throws [Exception] if flashcard not found or operation fails
  Future<FlashcardModel?> getFlashcardById(String id);

  /// Save a new flashcard
  ///
  /// Throws [Exception] if operation fails
  Future<void> saveFlashcard(FlashcardModel flashcard);

  /// Update an existing flashcard
  ///
  /// Throws [Exception] if flashcard not found or operation fails
  Future<void> updateFlashcard(FlashcardModel flashcard);

  /// Delete a flashcard by ID
  ///
  /// Throws [Exception] if flashcard not found or operation fails
  Future<void> deleteFlashcard(String id);

  /// Clear all flashcards (useful for testing)
  ///
  /// Throws [Exception] if operation fails
  Future<void> clearAll();
}
