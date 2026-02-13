import 'package:get_it/get_it.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Setup all application dependencies
///
/// This function should be called once during app initialization
/// before the root widget is created.
void setupDependencies() {
  // Core
  _setupCore();

  // Data sources
  _setupDataSources();

  // Repositories
  _setupRepositories();

  // Use cases
  _setupUseCases();

  // Stores
  _setupStores();
}

void _setupCore() {
  // Dio and API client will be setup here
  // For now, kept minimal as we'll build this progressively
}

void _setupDataSources() {
  // Flashcard local data source
  // Flashcard remote data source (AI)
}

void _setupRepositories() {
  // Flashcard repository
}

void _setupUseCases() {
  // Use cases will be registered here
}

void _setupStores() {
  // MobX stores will be registered here
}
