import 'package:fliplearnai/core/services/secure_storage_service.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/ai_remote_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/claude_datasource_impl.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/openai_datasource_impl.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';

/// Factory for selecting the appropriate AI datasource
///
/// Implements the Strategy pattern to dynamically choose between
/// Claude and OpenAI based on user configuration.
class AIDataSourceFactory implements AIRemoteDataSource {
  final ClaudeDataSourceImpl _claudeDataSource;
  final OpenAIDataSourceImpl _openAIDataSource;
  final SecureStorageService _storageService;

  static const _defaultProvider = 'claude';

  /// Constructor
  AIDataSourceFactory({
    required ClaudeDataSourceImpl claudeDataSource,
    required OpenAIDataSourceImpl openAIDataSource,
    required SecureStorageService storageService,
  })  : _claudeDataSource = claudeDataSource,
        _openAIDataSource = openAIDataSource,
        _storageService = storageService;

  @override
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String aiProvider,
    required String apiKey,
  }) async {
    // Get user's configured provider
    final provider = await _storageService.getProvider() ?? _defaultProvider;

    // Select appropriate datasource based on provider
    final dataSource = provider == 'openai'
        ? _openAIDataSource as AIRemoteDataSource
        : _claudeDataSource;

    // Delegate to selected datasource
    return dataSource.generateFlashcard(
      word: word,
      aiProvider: provider,
      apiKey: apiKey,
    );
  }
}
