import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';

/// Sample data fixtures for testing
class FlashcardFixtures {
  // Sample Flashcard Entities
  static final sampleFlashcard = Flashcard(
    id: '1',
    front: 'Hello',
    back: 'Olá',
    example: 'Hello world',
    pronunciation: '/həˈloʊ/',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  static final sampleFlashcardFavorite = Flashcard(
    id: '2',
    front: 'Goodbye',
    back: 'Adeus',
    example: 'Goodbye my friend',
    pronunciation: '/ɡʊdˈbaɪ/',
    isFavorite: true,
    createdAt: DateTime(2024, 1, 2),
    updatedAt: DateTime(2024, 1, 2),
  );

  static final sampleFlashcard3 = Flashcard(
    id: '3',
    front: 'Thank you',
    back: 'Obrigado',
    example: 'Thank you for your help',
    pronunciation: '/θæŋk juː/',
    createdAt: DateTime(2024, 1, 3),
    updatedAt: DateTime(2024, 1, 3),
  );

  static final sampleFlashcardList = [
    sampleFlashcard,
    sampleFlashcardFavorite,
    sampleFlashcard3,
  ];

  // Sample Flashcard Models (with JSON serialization)
  static final sampleFlashcardModel = FlashcardModel(
    id: '1',
    front: 'Hello',
    back: 'Olá',
    example: 'Hello world',
    pronunciation: '/həˈloʊ/',
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  static final sampleFlashcardModelList = [
    sampleFlashcardModel,
    FlashcardModel(
      id: '2',
      front: 'Goodbye',
      back: 'Adeus',
      example: 'Goodbye my friend',
      pronunciation: '/ɡʊdˈbaɪ/',
      isFavorite: true,
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  // Sample JSON responses
  static final sampleFlashcardJson = {
    'id': '1',
    'front': 'Hello',
    'back': 'Olá',
    'example': 'Hello world',
    'pronunciation': '/həˈloʊ/',
    'isFavorite': false,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-01T00:00:00.000Z',
  };

  static final sampleFlashcardListJson = [
    sampleFlashcardJson,
    {
      'id': '2',
      'front': 'Goodbye',
      'back': 'Adeus',
      'example': 'Goodbye my friend',
      'pronunciation': '/ɡʊdˈbaɪ/',
      'isFavorite': true,
      'createdAt': '2024-01-02T00:00:00.000Z',
      'updatedAt': '2024-01-02T00:00:00.000Z',
    },
  ];

  // Error scenarios
  static const String cacheErrorMessage = 'Cache error occurred';
  static const String networkErrorMessage = 'Network error occurred';
  static const String aiServiceErrorMessage = 'AI service error occurred';
  static const String validationErrorMessage = 'Validation failed';
}
