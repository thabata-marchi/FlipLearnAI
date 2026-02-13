import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

/// Parameters for GenerateFlashcardWithAI use case
class GenerateFlashcardWithAIParams {
  /// The word to generate a flashcard from (PT or EN)
  final String word;

  /// The AI provider to use (claude or openai)
  final String aiProvider;

  /// The API key for the AI provider
  final String apiKey;

  /// Constructor
  const GenerateFlashcardWithAIParams({
    required this.word,
    required this.aiProvider,
    required this.apiKey,
  });
}

/// Use case for generating a flashcard using AI
///
/// Takes a word and uses AI to generate a complete flashcard with
/// translation, examples, and pronunciation.
class GenerateFlashcardWithAI
    extends UseCase<Flashcard, GenerateFlashcardWithAIParams> {
  /// Repository dependency
  final FlashcardRepository repository;

  /// Constructor
  GenerateFlashcardWithAI(this.repository);

  /// Execute the use case
  ///
  /// Generates a flashcard from the provided word using AI
  @override
  Future<Either<Failure, Flashcard>> call(
    GenerateFlashcardWithAIParams params,
  ) {
    return repository.generateWithAI(
      word: params.word,
      aiProvider: params.aiProvider,
      apiKey: params.apiKey,
    );
  }
}
