import 'package:dartz/dartz.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';

/// Parameters for GenerateFlashcardWithAI use case
class GenerateFlashcardWithAIParams {

  /// Constructor
  const GenerateFlashcardWithAIParams({
    required this.word,
    required this.aiProvider,
    required this.apiKey,
  });
  /// The word to generate a flashcard from (PT or EN)
  final String word;

  /// The AI provider to use (claude or openai)
  final String aiProvider;

  /// The API key for the AI provider
  final String apiKey;
}

/// Use case for generating a flashcard using AI
///
/// Takes a word and uses AI to generate a complete flashcard with
/// translation, examples, and pronunciation.
class GenerateFlashcardWithAI
    extends UseCase<Flashcard, GenerateFlashcardWithAIParams> {

  /// Constructor
  GenerateFlashcardWithAI(this.repository);
  /// Repository dependency
  final FlashcardRepository repository;

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
