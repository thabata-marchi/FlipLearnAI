import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/services/secure_storage_service.dart';
import '../../features/flashcard/data/datasources/ai_datasource_factory.dart';
import '../../features/flashcard/data/datasources/ai_remote_datasource.dart';
import '../../features/flashcard/data/datasources/claude_datasource_impl.dart';
import '../../features/flashcard/data/datasources/flashcard_local_datasource.dart';
import '../../features/flashcard/data/datasources/flashcard_local_datasource_impl.dart';
import '../../features/flashcard/data/datasources/openai_datasource_impl.dart';
import '../../features/flashcard/data/models/flashcard_model.dart';
import '../../features/flashcard/data/repositories/flashcard_repository_impl.dart';
import '../../features/flashcard/domain/repositories/flashcard_repository.dart';
import '../../features/flashcard/domain/usecases/create_flashcard.dart';
import '../../features/flashcard/domain/usecases/delete_flashcard.dart';
import '../../features/flashcard/domain/usecases/generate_flashcard_with_ai.dart';
import '../../features/flashcard/domain/usecases/get_flashcard_by_id.dart';
import '../../features/flashcard/domain/usecases/get_flashcards.dart';
import '../../features/flashcard/domain/usecases/toggle_favorite.dart';
import '../../features/flashcard/presentation/stores/flashcard_store.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Setup all application dependencies
///
/// This function should be called once during app initialization
/// before the root widget is created.
void setupDependencies() {
  _setupCore();
  _setupDataSources();
  _setupRepositories();
  _setupUseCases();
  _setupStores();
}

/// Setup core services and utilities
void _setupCore() {
  // Dio HTTP client
  getIt.registerLazySingleton<Dio>(() => createDioClient());

  // Secure storage for API keys
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );

  // Network connectivity checker
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );

  // Hive box for flashcards
  getIt.registerLazySingleton<Box<FlashcardModel>>(
    () => Hive.box<FlashcardModel>('flashcards'),
  );
}

/// Setup data sources
void _setupDataSources() {
  // Local datasource
  getIt.registerLazySingleton<FlashcardLocalDataSource>(
    () => FlashcardLocalDataSourceImpl(getIt<Box<FlashcardModel>>()),
  );

  // Claude AI datasource
  getIt.registerLazySingleton<ClaudeDataSourceImpl>(
    () => ClaudeDataSourceImpl(
      dio: getIt<Dio>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );

  // OpenAI datasource
  getIt.registerLazySingleton<OpenAIDataSourceImpl>(
    () => OpenAIDataSourceImpl(
      dio: getIt<Dio>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );

  // AI datasource factory (selects between Claude and OpenAI)
  getIt.registerLazySingleton<AIRemoteDataSource>(
    () => AIDataSourceFactory(
      claudeDataSource: getIt<ClaudeDataSourceImpl>(),
      openAIDataSource: getIt<OpenAIDataSourceImpl>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );
}

/// Setup repository implementations
void _setupRepositories() {
  getIt.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(
      localDataSource: getIt<FlashcardLocalDataSource>(),
      remoteDataSource: getIt<AIRemoteDataSource>(),
    ),
  );
}

/// Setup use cases
void _setupUseCases() {
  // Get all flashcards
  getIt.registerLazySingleton(
    () => GetFlashcards(getIt<FlashcardRepository>()),
  );

  // Get flashcard by ID
  getIt.registerLazySingleton(
    () => GetFlashcardById(getIt<FlashcardRepository>()),
  );

  // Create flashcard
  getIt.registerLazySingleton(
    () => CreateFlashcard(getIt<FlashcardRepository>()),
  );

  // Delete flashcard
  getIt.registerLazySingleton(
    () => DeleteFlashcard(getIt<FlashcardRepository>()),
  );

  // Generate flashcard with AI
  getIt.registerLazySingleton(
    () => GenerateFlashcardWithAI(getIt<FlashcardRepository>()),
  );

  // Toggle favorite status
  getIt.registerLazySingleton(
    () => ToggleFavorite(getIt<FlashcardRepository>()),
  );
}

/// Setup MobX stores
void _setupStores() {
  getIt.registerLazySingleton(
    () => FlashcardStore(
      getFlashcardsUseCase: getIt<GetFlashcards>(),
      createFlashcardUseCase: getIt<CreateFlashcard>(),
      generateWithAIUseCase: getIt<GenerateFlashcardWithAI>(),
      toggleFavoriteUseCase: getIt<ToggleFavorite>(),
      deleteFlashcardUseCase: getIt<DeleteFlashcard>(),
    ),
  );
}
