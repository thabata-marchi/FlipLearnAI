# Feature Implementation Workflow

Padrão step-by-step para implementar features mantendo consistência arquitetural.

## 1. Planning Phase

- [ ] Defina a feature (problema que resolve)
- [ ] Identifique entidades envolvidas
- [ ] Liste endpoints de API necessários
- [ ] Crie branch: `feature/nome-feature`

**Exemplo:**
```
Feature: Criar flashcard com IA
Entidades: Flashcard, AIResponse
APIs: POST /api/flashcards/generate (AI service)
Branch: feature/ai-flashcard-generation
```

## 2. Domain Layer - Business Logic First

### 2.1 Create Entities
- [ ] Crie entity em `domain/entities/`
- [ ] Estenda `Equatable`
- [ ] Use `final` e `const`
- [ ] Sem lógica de serialização
- [ ] Documente com `///` comments

**File:** `lib/features/flashcard/domain/entities/flashcard.dart`

### 2.2 Define Repository Interface
- [ ] Crie abstract class em `domain/repositories/`
- [ ] Métodos retornam `Future<Either<Failure, Type>>`
- [ ] Defina contratos claros

**File:** `lib/features/flashcard/domain/repositories/flashcard_repository.dart`

### 2.3 Create Use Cases
- [ ] Um use case por operação
- [ ] Estenda `UseCase<ReturnType, Params>`
- [ ] Retorne `Either<Failure, Type>`
- [ ] Single responsibility
- [ ] Injete dependências via constructor

**Files:**
- `lib/features/flashcard/domain/usecases/get_flashcards.dart`
- `lib/features/flashcard/domain/usecases/create_flashcard.dart`
- `lib/features/flashcard/domain/usecases/generate_with_ai.dart`

### 2.4 Test Domain Layer
- [ ] Unit tests para todos use cases (100% coverage)
- [ ] Test happy path e error scenarios
- [ ] Mock repository

**Command:**
```bash
flutter test test/unit/domain/usecases/
```

**Expected:** All tests passing, 100% coverage

## 3. Data Layer - Implementation

### 3.1 Create Models
- [ ] Estenda entity ou compose
- [ ] `@JsonSerializable()`
- [ ] `@HiveType(typeId: X)`
- [ ] Método `toEntity()`
- [ ] Factory `fromJson()`

**File:** `lib/features/flashcard/data/models/flashcard_model.dart`

### 3.2 Define Data Sources (Abstract)
- [ ] Local datasource interface (Hive)
- [ ] Remote datasource interface (API)

**Files:**
- `lib/features/flashcard/data/datasources/flashcard_local_datasource.dart`
- `lib/features/flashcard/data/datasources/ai_remote_datasource.dart`

### 3.3 Implement Data Sources
- [ ] Local: Hive operations
- [ ] Remote: API calls com Dio
- [ ] Error handling (throw exceptions)
- [ ] No return of Either (that's repository's job)

**Files:**
- `lib/features/flashcard/data/datasources/flashcard_local_datasource_impl.dart`
- `lib/features/flashcard/data/datasources/ai_remote_datasource_impl.dart`

### 3.4 Implement Repository
- [ ] Implement domain repository interface
- [ ] Coordene local e remote datasources
- [ ] Converta exceptions em Failures
- [ ] Retorne Either<Failure, Type>

**File:** `lib/features/flashcard/data/repositories/flashcard_repository_impl.dart`

### 3.5 Test Data Layer
- [ ] Unit tests para repository (90%+ coverage)
- [ ] Mock datasources
- [ ] Test error scenarios

**Command:**
```bash
flutter test test/unit/data/
```

**Expected:** 90%+ coverage, all tests passing

## 4. Presentation Layer - UI & State

### 4.1 Create/Update MobX Store
- [ ] Define `@observable` state
- [ ] Defina `@action` methods
- [ ] Use `@computed` para valores derivados
- [ ] Injete use cases e repositories

**File:** `lib/features/flashcard/presentation/stores/flashcard_store.dart`

**Template:**
```dart
part 'flashcard_store.g.dart';

abstract class _FlashcardStoreBase with Store {
  final GetFlashcards getFlashcardsUseCase;

  _FlashcardStoreBase(this.getFlashcardsUseCase);

  @observable
  ObservableList<Flashcard> flashcards = ObservableList();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadFlashcards() async {
    // Implementation
  }
}

abstract class FlashcardStore = _FlashcardStoreBase with _$FlashcardStore;
```

### 4.2 Create Atoms (if needed)
- [ ] Componentes básicos reutilizáveis
- [ ] Nenhuma business logic
- [ ] Altamente configuráveis

### 4.3 Create Molecules (if needed)
- [ ] Combine atoms
- [ ] Simple state (focus, hover)
- [ ] Reusable building blocks

### 4.4 Create Organisms (if needed)
- [ ] Complex sections
- [ ] Coordene múltiplas molecules
- [ ] Sem business logic ainda

### 4.5 Create/Update Pages
- [ ] Use templates para layout
- [ ] Connect store via Provider
- [ ] Coordene user interactions
- [ ] Handle navigation

**File:** `lib/features/flashcard/presentation/pages/home_page.dart`

### 4.6 Setup Navigation
- [ ] Add route em `go_router` configuration
- [ ] Test navigation flow

### 4.7 Test Presentation Layer
- [ ] Widget tests para components (70%+ coverage)
- [ ] Mock stores
- [ ] Test UI interactions

**Command:**
```bash
flutter test test/widget/
```

**Expected:** 70%+ coverage

## 5. Dependency Injection Setup

- [ ] Register data sources em `core/di/injection.dart`
- [ ] Register repositories
- [ ] Register use cases
- [ ] Register stores

**File:** `lib/core/di/injection.dart`

```dart
void setupDependencies() {
  // Data sources
  getIt.registerLazySingleton<FlashcardLocalDataSource>(
    () => FlashcardLocalDataSourceImpl(...),
  );

  // Repositories
  getIt.registerLazySingleton<FlashcardRepository>(
    () => FlashcardRepositoryImpl(...),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetFlashcards(getIt()));

  // Stores
  getIt.registerLazySingleton(() => FlashcardStore(getIt()));
}
```

## 6. Build Runner Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Expected:** No errors, generated files created

## 7. Integration Testing

- [ ] Test complete user flow
- [ ] Verify navigation
- [ ] Test error scenarios

**File:** `integration_test/flashcard_flow_test.dart`

## 8. Code Quality

- [ ] Run analysis: `flutter analyze`
- [ ] Format: `dart format . --fix`
- [ ] Coverage: `flutter test --coverage`

**Expected:**
- Zero linter warnings
- Coverage >= 80%

## 9. Git Commit

```bash
git add .
git commit -m "feat(flashcard): implement feature description

- Added domain layer (entities, repositories, usecases)
- Implemented data layer with Hive and API integration
- Created presentation layer with stores and UI components
- Added comprehensive tests (80%+ coverage)
- Integrated with DI container

Closes #123"
```

## 10. Code Review Checklist

- [ ] Architecture rules followed
- [ ] Tests pass and coverage >= 80%
- [ ] No linter warnings
- [ ] Code is formatted
- [ ] No hardcoded strings
- [ ] Error handling implemented
- [ ] Documentation added
- [ ] No API keys or secrets
- [ ] Navigation works correctly

## Troubleshooting

### MobX Generation Issues
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Hive Type Conflicts
- Increment `typeId` in new `@HiveType` decorators
- Never reuse typeIds

### DI Registration Order
- Register dependencies before dependent items
- Use lazy singletons to avoid initialization issues

### Test Failures
- Ensure mocks match interface signatures
- Check mock setup before assertions
- Use `any` matcher for flexible matching

## Quick Reference

### Files to Create
```
Domain:
  ├── domain/entities/flashcard.dart
  ├── domain/repositories/flashcard_repository.dart
  └── domain/usecases/
      ├── get_flashcards.dart
      ├── create_flashcard.dart
      └── generate_with_ai.dart

Data:
  ├── data/models/flashcard_model.dart
  ├── data/datasources/
  │   ├── flashcard_local_datasource.dart
  │   ├── flashcard_local_datasource_impl.dart
  │   ├── ai_remote_datasource.dart
  │   └── ai_remote_datasource_impl.dart
  └── data/repositories/
      └── flashcard_repository_impl.dart

Presentation:
  ├── presentation/stores/flashcard_store.dart
  ├── presentation/atoms/
  ├── presentation/molecules/
  ├── presentation/organisms/
  └── presentation/pages/home_page.dart

Test:
  ├── test/unit/domain/usecases/
  ├── test/unit/data/
  ├── test/widget/
  └── integration_test/
```

### Command Quick Reference

```bash
# Create project
flutter create --org ai.fliplearn fliplearnai

# Setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Development (watch mode for code generation)
flutter pub run build_runner watch --delete-conflicting-outputs

# Testing
flutter test                          # all tests
flutter test --coverage              # with coverage
flutter test test/unit/domain/       # specific directory
flutter test --name="should_"        # by pattern

# Code quality
flutter analyze                       # linting
dart format . --fix                   # formatting
dart format --set-exit-if-changed .   # check only

# Coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Build
flutter build apk --release
flutter build web --release
flutter build ios --release

# Git
git checkout -b feature/name
git add .
git commit -m "feat(scope): description"
git push -u origin feature/name
```

## Success Criteria

✅ Domain layer: 100% test coverage
✅ Data layer: 90%+ test coverage
✅ Presentation layer: 70%+ test coverage
✅ Overall: 80%+ test coverage
✅ Zero linter warnings
✅ Code formatted correctly
✅ All tests passing
✅ Feature fully functional
✅ Documentation updated
✅ Code reviewed and approved
