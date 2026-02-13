import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/create_flashcard.dart';
import '../../domain/usecases/generate_flashcard_with_ai.dart';
import '../../domain/usecases/get_flashcards.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../../../core/usecases/usecase.dart';

part 'flashcard_store.g.dart';

/// MobX store for flashcard feature
///
/// Manages flashcard state and orchestrates use cases
class FlashcardStore = _FlashcardStoreBase with _$FlashcardStore;

abstract class _FlashcardStoreBase with Store {
  /// Get flashcards use case
  final GetFlashcards getFlashcardsUseCase;

  /// Create flashcard use case
  final CreateFlashcard createFlashcardUseCase;

  /// Generate flashcard with AI use case
  final GenerateFlashcardWithAI generateWithAIUseCase;

  /// Toggle favorite use case
  final ToggleFavorite toggleFavoriteUseCase;

  /// Constructor
  _FlashcardStoreBase({
    required this.getFlashcardsUseCase,
    required this.createFlashcardUseCase,
    required this.generateWithAIUseCase,
    required this.toggleFavoriteUseCase,
  });

  /// List of all flashcards
  @observable
  ObservableList<Flashcard> flashcards = ObservableList<Flashcard>();

  /// Whether data is loading
  @observable
  bool isLoading = false;

  /// Error message if any
  @observable
  String? errorMessage;

  /// Whether currently generating with AI
  @observable
  bool isGeneratingWithAI = false;

  /// Search query
  @observable
  String searchQuery = '';

  /// Filtered flashcards based on search query
  @computed
  List<Flashcard> get filteredFlashcards {
    if (searchQuery.isEmpty) {
      return flashcards.toList();
    }
    final query = searchQuery.toLowerCase();
    return flashcards
        .where(
          (card) =>
              card.front.toLowerCase().contains(query) ||
              card.back.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Count of favorite flashcards
  @computed
  int get favoritesCount =>
      flashcards.where((card) => card.isFavorite).length;

  /// Count of total flashcards
  @computed
  int get totalCount => flashcards.length;

  /// Load all flashcards
  @action
  Future<void> loadFlashcards() async {
    isLoading = true;
    errorMessage = null;

    final result = await getFlashcardsUseCase(const NoParams());

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (cards) {
        flashcards = ObservableList<Flashcard>.of(cards);
      },
    );

    isLoading = false;
  }

  /// Create a new flashcard
  @action
  Future<void> createFlashcard(Flashcard flashcard) async {
    final result = await createFlashcardUseCase(
      CreateFlashcardParams(flashcard: flashcard),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (created) {
        flashcards.add(created);
        errorMessage = null;
      },
    );
  }

  /// Generate a flashcard using AI
  @action
  Future<void> generateFlashcardWithAI({
    required String word,
    required String aiProvider,
    required String apiKey,
  }) async {
    isGeneratingWithAI = true;
    errorMessage = null;

    final result = await generateWithAIUseCase(
      GenerateFlashcardWithAIParams(
        word: word,
        aiProvider: aiProvider,
        apiKey: apiKey,
      ),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (generated) {
        flashcards.add(generated);
        errorMessage = null;
      },
    );

    isGeneratingWithAI = false;
  }

  /// Toggle favorite status of a flashcard
  @action
  Future<void> toggleFavorite(String flashcardId) async {
    final result = await toggleFavoriteUseCase(
      ToggleFavoriteParams(flashcardId: flashcardId),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (updated) {
        final index =
            flashcards.indexWhere((card) => card.id == flashcardId);
        if (index >= 0) {
          flashcards[index] = updated;
        }
      },
    );
  }

  /// Update search query
  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  /// Clear error message
  @action
  void clearError() {
    errorMessage = null;
  }

  /// Clear all flashcards (useful for testing)
  @action
  void clearFlashcards() {
    flashcards.clear();
  }
}
