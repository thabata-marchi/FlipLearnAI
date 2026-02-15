import 'package:fliplearnai/core/usecases/usecase.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/create_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/delete_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/generate_flashcard_with_ai.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/get_flashcards.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/toggle_favorite.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/update_flashcard.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'flashcard_store.g.dart';

/// Sort options for flashcards
enum FlashcardSortOption {
  /// Sort by creation date, newest first
  newestFirst('Newest First'),

  /// Sort by creation date, oldest first
  oldestFirst('Oldest First'),

  /// Sort alphabetically by front text (A-Z)
  alphabeticalAZ('A-Z (English)'),

  /// Sort alphabetically by front text (Z-A)
  alphabeticalZA('Z-A (English)'),

  /// Sort favorites first, then by date
  favoritesFirst('Favorites First');

  const FlashcardSortOption(this.label);

  /// Display label for the sort option
  final String label;
}

/// MobX store for flashcard feature
///
/// Manages flashcard state and orchestrates use cases
class FlashcardStore = _FlashcardStoreBase with _$FlashcardStore;

abstract class _FlashcardStoreBase with Store {
  /// Constructor
  _FlashcardStoreBase({
    required GetFlashcards getFlashcardsUseCase,
    required CreateFlashcard createFlashcardUseCase,
    required GenerateFlashcardWithAI generateWithAIUseCase,
    required ToggleFavorite toggleFavoriteUseCase,
    required DeleteFlashcard deleteFlashcardUseCase,
    required UpdateFlashcard updateFlashcardUseCase,
  })  : getFlashcardsUseCase = getFlashcardsUseCase,
        createFlashcardUseCase = createFlashcardUseCase,
        generateWithAIUseCase = generateWithAIUseCase,
        toggleFavoriteUseCase = toggleFavoriteUseCase,
        deleteFlashcardUseCase = deleteFlashcardUseCase,
        updateFlashcardUseCase = updateFlashcardUseCase {
    _loadSortOption();
  }

  /// Get flashcards use case
  final GetFlashcards getFlashcardsUseCase;

  /// Create flashcard use case
  final CreateFlashcard createFlashcardUseCase;

  /// Generate flashcard with AI use case
  final GenerateFlashcardWithAI generateWithAIUseCase;

  /// Toggle favorite use case
  final ToggleFavorite toggleFavoriteUseCase;

  /// Delete flashcard use case
  final DeleteFlashcard deleteFlashcardUseCase;

  /// Update flashcard use case
  final UpdateFlashcard updateFlashcardUseCase;

  static const _sortOptionKey = 'flashcard_sort_option';

  /// Load saved sort option from SharedPreferences
  Future<void> _loadSortOption() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_sortOptionKey);
      if (savedIndex != null &&
          savedIndex >= 0 &&
          savedIndex < FlashcardSortOption.values.length) {
        sortOption = FlashcardSortOption.values[savedIndex];
      }
    } catch (e) {
      // Ignore errors, use default
    }
  }

  /// Save sort option to SharedPreferences
  Future<void> _saveSortOption() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_sortOptionKey, sortOption.index);
    } catch (e) {
      // Ignore errors
    }
  }

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

  /// Whether a flashcard was just created successfully
  @observable
  bool wasJustCreated = false;

  /// Search query
  @observable
  String searchQuery = '';

  /// Current sort option
  @observable
  FlashcardSortOption sortOption = FlashcardSortOption.newestFirst;

  /// Filtered and sorted flashcards based on search query and sort option
  @computed
  List<Flashcard> get filteredFlashcards {
    // First, filter by search query
    var result = flashcards.toList();

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where(
            (card) =>
                card.front.toLowerCase().contains(query) ||
                card.back.toLowerCase().contains(query),
          )
          .toList();
    }

    // Then, apply sorting
    switch (sortOption) {
      case FlashcardSortOption.newestFirst:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case FlashcardSortOption.oldestFirst:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case FlashcardSortOption.alphabeticalAZ:
        result.sort(
          (a, b) => a.front.toLowerCase().compareTo(b.front.toLowerCase()),
        );
      case FlashcardSortOption.alphabeticalZA:
        result.sort(
          (a, b) => b.front.toLowerCase().compareTo(a.front.toLowerCase()),
        );
      case FlashcardSortOption.favoritesFirst:
        result.sort((a, b) {
          // First sort by favorite status
          if (a.isFavorite != b.isFavorite) {
            return a.isFavorite ? -1 : 1;
          }
          // Then by date (newest first)
          return b.createdAt.compareTo(a.createdAt);
        });
    }

    return result;
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
    isLoading = true;
    wasJustCreated = false;

    final result = await createFlashcardUseCase(
      CreateFlashcardParams(flashcard: flashcard),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        wasJustCreated = false;
      },
      (created) {
        flashcards.add(created);
        errorMessage = null;
        wasJustCreated = true;
      },
    );

    isLoading = false;
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
    wasJustCreated = false;

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
        wasJustCreated = false;
      },
      (generated) {
        flashcards.add(generated);
        errorMessage = null;
        wasJustCreated = true;
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

  /// Update an existing flashcard
  @action
  Future<void> updateFlashcard(Flashcard flashcard) async {
    isLoading = true;
    wasJustCreated = false;

    final result = await updateFlashcardUseCase(
      UpdateFlashcardParams(flashcard: flashcard),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        wasJustCreated = false;
      },
      (updated) {
        final index = flashcards.indexWhere((card) => card.id == updated.id);
        if (index >= 0) {
          flashcards[index] = updated;
        }
        errorMessage = null;
        wasJustCreated = true;
      },
    );

    isLoading = false;
  }

  /// Delete a flashcard
  @action
  Future<void> deleteFlashcard(String flashcardId) async {
    final result = await deleteFlashcardUseCase(
      DeleteFlashcardParams(flashcardId: flashcardId),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (_) {
        flashcards.removeWhere((card) => card.id == flashcardId);
        errorMessage = null;
      },
    );
  }

  /// Update search query
  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  /// Update sort option
  @action
  void setSortOption(FlashcardSortOption option) {
    sortOption = option;
    _saveSortOption();
  }

  /// Clear error message
  @action
  void clearError() {
    errorMessage = null;
  }

  /// Reset creation state
  @action
  void resetCreationState() {
    wasJustCreated = false;
    errorMessage = null;
  }

  /// Clear all flashcards (useful for testing)
  @action
  void clearFlashcards() {
    flashcards.clear();
  }
}
