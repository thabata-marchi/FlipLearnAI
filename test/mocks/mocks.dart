import 'package:mocktail/mocktail.dart';

import 'package:fliplearnai/core/errors/failures.dart';
import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/ai_remote_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/create_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/delete_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/generate_flashcard_with_ai.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/get_flashcard_by_id.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/get_flashcards.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/toggle_favorite.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';

// Repository Mocks
class MockFlashcardRepository extends Mock implements FlashcardRepository {}

// Data Source Mocks
class MockFlashcardLocalDataSource extends Mock
    implements FlashcardLocalDataSource {}

class MockAIRemoteDataSource extends Mock implements AIRemoteDataSource {}

// Use Case Mocks
class MockGetFlashcards extends Mock implements GetFlashcards {}

class MockGetFlashcardById extends Mock implements GetFlashcardById {}

class MockCreateFlashcard extends Mock implements CreateFlashcard {}

class MockDeleteFlashcard extends Mock implements DeleteFlashcard {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

class MockGenerateFlashcardWithAI extends Mock
    implements GenerateFlashcardWithAI {}

// Store Mocks
class MockFlashcardStore extends Mock implements FlashcardStore {}

// Register fallback values for mocktail
void setUpMockFallbackValues() {
  registerFallbackValue(const NoParams());
  registerFallbackValue(const GetFlashcardByIdParams(flashcardId: ''));
  registerFallbackValue(CreateFlashcardParams(
    flashcard: Flashcard(
      id: '',
      front: '',
      back: '',
      createdAt: DateTime(2024),
    ),
  ));
  registerFallbackValue(const DeleteFlashcardParams(flashcardId: ''));
  registerFallbackValue(const ToggleFavoriteParams(flashcardId: ''));
  registerFallbackValue(const GenerateFlashcardWithAIParams(
    word: '',
    aiProvider: 'claude',
    apiKey: '',
  ));
  registerFallbackValue(CacheFailure(''));
  registerFallbackValue(NetworkFailure(''));
  registerFallbackValue(AIServiceFailure(''));
  registerFallbackValue(ValidationFailure(''));
}
