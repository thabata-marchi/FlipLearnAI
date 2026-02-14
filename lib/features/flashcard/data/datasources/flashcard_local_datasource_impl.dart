import 'package:fliplearnai/core/errors/exceptions.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:hive/hive.dart';

/// Implementation of FlashcardLocalDataSource using Hive
///
/// Provides local storage operations for flashcards using Hive database.
/// All methods are wrapped in error handling to throw [CacheException] on failure.
class FlashcardLocalDataSourceImpl implements FlashcardLocalDataSource {
  final Box<FlashcardModel> _box;

  /// Constructor
  ///
  /// Requires a Hive Box instance for FlashcardModel storage.
  FlashcardLocalDataSourceImpl(this._box);

  @override
  Future<List<FlashcardModel>> getFlashcards() async {
    try {
      final flashcards = _box.values.toList();
      return flashcards;
    } catch (e) {
      throw CacheException('Failed to retrieve flashcards: $e');
    }
  }

  @override
  Future<FlashcardModel?> getFlashcardById(String id) async {
    try {
      final flashcard = _box.get(id);
      return flashcard;
    } catch (e) {
      throw CacheException('Failed to retrieve flashcard: $e');
    }
  }

  @override
  Future<void> saveFlashcard(FlashcardModel flashcard) async {
    try {
      await _box.put(flashcard.id, flashcard);
    } catch (e) {
      throw CacheException('Failed to save flashcard: $e');
    }
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    try {
      // Check if flashcard exists
      if (!_box.containsKey(flashcard.id)) {
        throw CacheException('Flashcard not found');
      }
      await _box.put(flashcard.id, flashcard);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to update flashcard: $e');
    }
  }

  @override
  Future<void> deleteFlashcard(String id) async {
    try {
      if (!_box.containsKey(id)) {
        throw CacheException('Flashcard not found');
      }
      await _box.delete(id);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to delete flashcard: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException('Failed to clear flashcards: $e');
    }
  }
}
