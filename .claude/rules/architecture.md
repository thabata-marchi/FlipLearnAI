# Clean Architecture & Architecture Guidelines

## Overview

FlipLearnAI follows **Clean Architecture** with clear separation of concerns across three main layers: Domain, Data, and Presentation. This ensures the code is testable, maintainable, and independent of frameworks.

## Layer Dependencies

```
┌─────────────────────────────────────────────────┐
│           PRESENTATION LAYER                     │
│  (UI, Pages, Stores, Widgets)                   │
└──────────────┬──────────────────────────────────┘
               │ depends on
┌──────────────▼──────────────────────────────────┐
│           DATA LAYER                             │
│  (Repositories, DataSources, Models)            │
└──────────────┬──────────────────────────────────┘
               │ depends on
┌──────────────▼──────────────────────────────────┐
│           DOMAIN LAYER                           │
│  (Entities, Use Cases, Repository Interfaces)   │
└──────────────────────────────────────────────────┘
```

**Critical Rule:** Each layer can ONLY depend on layers below it. No circular dependencies.

## Domain Layer (lib/features/*/domain/)

**Pure Dart code - NO Flutter dependencies**

### Entities
- Pure business objects (e.g., `Flashcard`, `User`)
- Immutable (use `final`)
- Use `Equatable` for equality comparison
- No serialization logic

```dart
class Flashcard extends Equatable {
  final String id;
  final String front;
  final String back;
  final String? example;
  final bool isFavorite;

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.example,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [id, front, back, example, isFavorite];
}
```

### Repository Interfaces
- Abstract classes defining data access contracts
- Located in `domain/repositories/`
- Return `Future<Either<Failure, Type>>`
- Should NOT contain implementation details

```dart
abstract class FlashcardRepository {
  Future<Either<Failure, List<Flashcard>>> getAll();
  Future<Either<Failure, Flashcard>> getById(String id);
  Future<Either<Failure, Flashcard>> create(Flashcard flashcard);
  Future<Either<Failure, Unit>> delete(String id);
}
```

### Use Cases
- Encapsulate business operations
- Single responsibility principle (one operation per use case)
- Extend `UseCase<ReturnType, Params>`
- Always return `Either<Failure, Success>`

```dart
class GetFlashcards extends UseCase<List<Flashcard>, NoParams> {
  final FlashcardRepository repository;

  GetFlashcards(this.repository);

  @override
  Future<Either<Failure, List<Flashcard>>> call(NoParams params) {
    return repository.getAll();
  }
}
```

### Failures
- Custom failure classes for different error types
- Located in `core/errors/failures.dart`
- Use sealed classes or inheritance

```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class AIServiceFailure extends Failure {
  final String? code;
  AIServiceFailure(String message, {this.code}) : super(message);
}
```

## Data Layer (lib/features/*/data/)

**Implements repository interfaces from domain**

### Models
- Extend or compose domain entities
- JSON serializable (`@JsonSerializable`)
- Hive adaptable (`@HiveType`) for local persistence
- Convert to entities via `toEntity()` method

```dart
@JsonSerializable()
@HiveType(typeId: 0)
class FlashcardModel extends Flashcard {
  const FlashcardModel({
    @JsonKey(name: 'id')
    @HiveField(0)
    required String id,
    @JsonKey(name: 'front')
    @HiveField(1)
    required String front,
    @JsonKey(name: 'back')
    @HiveField(2)
    required String back,
    @JsonKey(name: 'example')
    @HiveField(3)
    String? example,
    @JsonKey(name: 'isFavorite')
    @HiveField(4)
    bool isFavorite = false,
  }) : super(
    id: id,
    front: front,
    back: back,
    example: example,
    isFavorite: isFavorite,
  );

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlashcardModelToJson(this);

  factory FlashcardModel.fromEntity(Flashcard entity) => FlashcardModel(
    id: entity.id,
    front: entity.front,
    back: entity.back,
    example: entity.example,
    isFavorite: entity.isFavorite,
  );
}
```

### Data Sources
- **Local:** Access to Hive (cached/offline data)
- **Remote:** API calls to AI services and external APIs
- Abstract classes in same directory
- Concrete implementations handle framework-specific logic

```dart
abstract class FlashcardLocalDataSource {
  Future<List<FlashcardModel>> getFlashcards();
  Future<void> saveFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String id);
}

class FlashcardLocalDataSourceImpl extends FlashcardLocalDataSource {
  final HiveInterface hive;

  FlashcardLocalDataSourceImpl(this.hive);

  @override
  Future<List<FlashcardModel>> getFlashcards() async {
    final box = await hive.openBox<FlashcardModel>('flashcards');
    return box.values.toList();
  }
  // ...
}
```

### Repository Implementation
- Implements domain repository interface
- Coordinates between local and remote data sources
- Handles errors and converts to Failures
- Implements caching strategy

```dart
class FlashcardRepositoryImpl extends FlashcardRepository {
  final FlashcardLocalDataSource localDataSource;
  final AIRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FlashcardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Flashcard>>> getAll() async {
    try {
      final models = await localDataSource.getFlashcards();
      return Right(models);
    } catch (e) {
      return Left(CacheFailure('Failed to load flashcards'));
    }
  }
}
```

## Presentation Layer (lib/features/*/presentation/)

**Flutter code - MobX stores + UI components**

### MobX Stores
- Manage feature state and logic
- Use `@observable` for state
- Use `@action` for mutations
- Use `@computed` for derived values
- Located in `stores/` subdirectory

```dart
part 'flashcard_store.g.dart';

abstract class _FlashcardStoreBase with Store {
  final GetFlashcards getFlashcardsUseCase;
  final CreateFlashcard createFlashcardUseCase;

  _FlashcardStoreBase(
    this.getFlashcardsUseCase,
    this.createFlashcardUseCase,
  );

  @observable
  ObservableList<Flashcard> flashcards = ObservableList();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadFlashcards() async {
    isLoading = true;
    errorMessage = null;

    final result = await getFlashcardsUseCase(NoParams());
    result.fold(
      (failure) => errorMessage = failure.message,
      (cards) => flashcards = ObservableList.of(cards),
    );

    isLoading = false;
  }

  @computed
  List<Flashcard> get favorites =>
      flashcards.where((card) => card.isFavorite).toList();
}

abstract class FlashcardStore = _FlashcardStoreBase with _$FlashcardStore;
```

### UI Components (Atomic Design)
- **Atoms:** Smallest reusable components (Button, TextField, Card)
- **Molecules:** Combinations of atoms (SearchBar, FlashcardItem)
- **Organisms:** Complex sections (FlashcardList, AIPanel)
- **Pages:** Full screens composed from organisms
- **Templates:** Reusable layouts for pages

No business logic in UI components - only presentation logic.

## Dependency Injection (DI)

**Configuration in `lib/core/di/injection.dart`**

```dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Data sources
  getIt.registerLazySingleton<FlashcardLocalDataSource>(
    () => FlashcardLocalDataSourceImpl(HiveInterface()),
  );

  getIt.registerLazySingleton<AIRemoteDataSource>(
    () => AIRemoteDataSourceImpl(Dio()),
  );

  // Repositories
  getIt.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetFlashcards(getIt()));
  getIt.registerLazySingleton(() => CreateFlashcard(getIt()));

  // Stores
  getIt.registerLazySingleton(
    () => FlashcardStore(getIt(), getIt()),
  );
}
```

**Usage:**
```dart
void main() {
  setupDependencies();
  runApp(const MyApp());
}

// In widgets:
final store = getIt<FlashcardStore>();
```

## Error Handling

### Either Pattern (dartz)
- Success: `Right<Failure, Type>`
- Failure: `Left<Failure, Type>`
- Never throw exceptions across layers

```dart
// Use case returns Either
Future<Either<Failure, Flashcard>> create(Flashcard flashcard);

// Handle result
final result = await usecase(params);
result.fold(
  (failure) => showError(failure.message),  // Error
  (flashcard) => showSuccess(flashcard),     // Success
);
```

### Exception Handling
- Catch exceptions in data sources only
- Convert to Failures immediately
- Never expose exceptions to higher layers

```dart
@override
Future<List<Flashcard>> getFlashcards() async {
  try {
    final response = await dio.get('/flashcards');
    return (response.data as List)
        .map((json) => FlashcardModel.fromJson(json))
        .toList();
  } on DioException catch (e) {
    throw NetworkException(e.message ?? 'Network error');
  } catch (e) {
    throw UnknownException('Unknown error');
  }
}
```

## Naming Conventions

### Files
- snake_case: `flashcard_store.dart`, `flashcard_repository.dart`

### Classes
- PascalCase: `Flashcard`, `FlashcardStore`, `GetFlashcards`
- Entities end with noun: `Flashcard`, `User`
- Use cases follow verb pattern: `GetFlashcards`, `CreateFlashcard`, `DeleteFlashcard`
- Repositories end with `Repository`: `FlashcardRepository`
- Data sources end with `DataSource`: `FlashcardLocalDataSource`
- Stores end with `Store`: `FlashcardStore`

### Variables & Methods
- camelCase: `flashcards`, `isLoading`, `loadFlashcards()`

## File Organization

```
lib/
├── core/                      # Shared utilities
│   ├── di/                    # Dependency injection
│   ├── errors/                # Failure & exception classes
│   ├── network/               # API client setup
│   ├── usecases/              # Base UseCase class
│   └── utils/                 # Constants, validators, etc
│
├── features/
│   └── flashcard/             # Feature module
│       ├── domain/            # Business logic
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/              # Data implementation
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       └── presentation/      # UI layer
│           ├── stores/
│           ├── atoms/
│           ├── molecules/
│           ├── organisms/
│           └── pages/
│
├── shared/                    # Shared UI/utilities
│   ├── themes/
│   └── widgets/
│
└── main.dart
```

## Testing Implications

- Domain layer code: 100% test coverage (no external dependencies)
- Data layer code: 90%+ coverage (mock external services)
- Presentation layer: 70%+ coverage (test logic, not rendering)

## When to Refactor

- Extract common code into utilities only after 3 similar usages
- Keep layers clear - move code if it violates layer boundaries
- Regular architecture reviews in code reviews

## References

- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- MobX: https://mobx.js.org/intro/overview.html
- Either Pattern: https://pub.dev/packages/dartz
