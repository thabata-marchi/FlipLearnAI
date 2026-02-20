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

  /// Constructor
  AIDataSourceFactory({
    required ClaudeDataSourceImpl claudeDataSource,
    required OpenAIDataSourceImpl openAIDataSource,
    required SecureStorageService storageService,
  })  : _claudeDataSource = claudeDataSource,
        _openAIDataSource = openAIDataSource,
        _storageService = storageService;
  final ClaudeDataSourceImpl _claudeDataSource;
  final OpenAIDataSourceImpl _openAIDataSource;
  final SecureStorageService _storageService;

  static const _defaultProvider = 'claude';

  @override
  Future<FlashcardModel> generateFlashcard({
    required String word,
    required String aiProvider,
    required String apiKey,
  }) async {
    // Get provider to use: prefer parameter, fallback to storage, then default
    final providerToUse = aiProvider.isNotEmpty
        ? aiProvider
        : (await _storageService.getProvider() ?? _defaultProvider);

    // Get API key from storage if not provided
    final keyToUse = apiKey.isNotEmpty
        ? apiKey
        : (await _storageService.getApiKey() ?? '');

    // Select appropriate datasource based on provider
    final dataSource = providerToUse == 'openai'
        ? _openAIDataSource
        : _claudeDataSource;

    // Delegate to selected datasource
    return dataSource.generateFlashcard(
      word: word,
      aiProvider: providerToUse,
      apiKey: keyToUse,
    );
  }
}
