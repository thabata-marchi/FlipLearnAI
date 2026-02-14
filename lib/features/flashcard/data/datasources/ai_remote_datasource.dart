import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Abstract remote data source for AI-powered flashcard generation
///
/// Defines contracts for calling AI services to generate flashcards
abstract class AIRemoteDataSource {
  /// Generate a flashcard using AI
  ///
  /// Takes a word and generates a complete flashcard with translation,
  /// examples, and pronunciation using the specified AI provider.
  ///
  /// Parameters:
  ///   - word: The input word (PT or EN)
  ///   - aiProvider: The AI provider (claude or openai)
  ///   - apiKey: The API key for the AI provider
  ///
  /// Throws [Exception] if the API call fails
  /// Returns a [FlashcardModel] with all fields populated by AI
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String aiProvider,
    required String apiKey,
  });
}
