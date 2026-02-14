import 'package:dio/dio.dart';
import 'package:fliplearnai/core/network/dio_client.dart';
import 'package:fliplearnai/core/network/network_info.dart';
import 'package:fliplearnai/core/services/secure_storage_service.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/ai_datasource_factory.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/ai_remote_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/claude_datasource_impl.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/flashcard_local_datasource_impl.dart';
import 'package:fliplearnai/features/flashcard/data/datasources/openai_datasource_impl.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:fliplearnai/features/flashcard/data/repositories/flashcard_repository_impl.dart';
import 'package:fliplearnai/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/create_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/delete_flashcard.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/generate_flashcard_with_ai.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/get_flashcard_by_id.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/get_flashcards.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/toggle_favorite.dart';
import 'package:fliplearnai/features/flashcard/domain/usecases/update_flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

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
  getIt
    // Dio HTTP client
    ..registerLazySingleton<Dio>(createDioClient)

    // Secure storage for API keys
    ..registerLazySingleton<SecureStorageService>(
      SecureStorageServiceImpl.new,
    )

    // Network connectivity checker
    ..registerLazySingleton<NetworkInfo>(
      NetworkInfoImpl.new,
    )

    // Hive box for flashcards
    ..registerLazySingleton<Box<FlashcardModel>>(
      () => Hive.box<FlashcardModel>('flashcards'),
    );
}

/// Setup data sources
void _setupDataSources() {
  getIt
    // Local datasource
    ..registerLazySingleton<FlashcardLocalDataSource>(
      () => FlashcardLocalDataSourceImpl(getIt<Box<FlashcardModel>>()),
    )

    // Claude AI datasource
    ..registerLazySingleton<ClaudeDataSourceImpl>(
      () => ClaudeDataSourceImpl(
        dio: getIt<Dio>(),
      ),
    )

    // OpenAI datasource
    ..registerLazySingleton<OpenAIDataSourceImpl>(
      () => OpenAIDataSourceImpl(
        dio: getIt<Dio>(),
      ),
    )

    // AI datasource factory (selects between Claude and OpenAI)
    ..registerLazySingleton<AIRemoteDataSource>(
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
  getIt
    // Get all flashcards
    ..registerLazySingleton(
      () => GetFlashcards(getIt<FlashcardRepository>()),
    )

    // Get flashcard by ID
    ..registerLazySingleton(
      () => GetFlashcardById(getIt<FlashcardRepository>()),
    )

    // Create flashcard
    ..registerLazySingleton(
      () => CreateFlashcard(getIt<FlashcardRepository>()),
    )

    // Update flashcard
    ..registerLazySingleton(
      () => UpdateFlashcard(getIt<FlashcardRepository>()),
    )

    // Delete flashcard
    ..registerLazySingleton(
      () => DeleteFlashcard(getIt<FlashcardRepository>()),
    )

    // Generate flashcard with AI
    ..registerLazySingleton(
      () => GenerateFlashcardWithAI(getIt<FlashcardRepository>()),
    )

    // Toggle favorite status
    ..registerLazySingleton(
      () => ToggleFavorite(getIt<FlashcardRepository>()),
    );
}

/// Setup MobX stores
void _setupStores() {
  getIt
    // AI Configuration store
    ..registerLazySingleton(
      () => AIConfigStore(
        storageService: getIt<SecureStorageService>(),
      ),
    )

    // Flashcard store
    ..registerLazySingleton(
      () => FlashcardStore(
        getFlashcardsUseCase: getIt<GetFlashcards>(),
        createFlashcardUseCase: getIt<CreateFlashcard>(),
        generateWithAIUseCase: getIt<GenerateFlashcardWithAI>(),
        toggleFavoriteUseCase: getIt<ToggleFavorite>(),
        deleteFlashcardUseCase: getIt<DeleteFlashcard>(),
        updateFlashcardUseCase: getIt<UpdateFlashcard>(),
      ),
    );
}
