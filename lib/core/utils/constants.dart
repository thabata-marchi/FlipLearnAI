/// Application constants
class AppConstants {
  /// App name
  static const String appName = 'FlipLearnAI';

  /// App version
  static const String appVersion = '1.0.0';

  /// API timeout duration in seconds
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Cache duration for flashcards
  static const Duration cacheDuration = Duration(hours: 24);

  /// Maximum number of retry attempts for API calls
  static const int maxRetries = 3;

  /// Delay between retry attempts in milliseconds
  static const Duration retryDelay = Duration(milliseconds: 1000);
}

/// Hive box names
class HiveBoxes {
  /// Flashcards box name
  static const String flashcards = 'flashcards';

  /// API configuration box name
  static const String apiConfig = 'api_config';

  /// User preferences box name
  static const String preferences = 'preferences';
}

/// Error messages
class ErrorMessages {
  /// Network connectivity error message
  static const String networkError =
      'Network error. Please check your connection.';

  /// Cache retrieval error message
  static const String cacheError = 'Failed to load cached data.';

  /// AI service error message
  static const String aiServiceError = 'AI service error. Please try again.';

  /// Unknown error fallback message
  static const String unknownError = 'An unknown error occurred.';

  /// Invalid input error message
  static const String invalidInput = 'Invalid input provided.';
}

/// AI Provider constants
class AIProviders {
  /// Claude AI provider identifier
  static const String claude = 'claude';

  /// OpenAI provider identifier
  static const String openai = 'openai';
}
