# Testing Guidelines & Coverage Requirements

## Coverage Targets

**Overall: 80% minimum**

- **Domain Layer:** 100% (pure Dart, no dependencies)
- **Data Layer:** 90%+ (mock external services)
- **Presentation Layer:** 70%+ (test logic, not rendering)

## Test File Organization

Mirror the source structure in `test/` directory:

```
test/
├── unit/
│   ├── domain/
│   │   ├── usecases/
│   │   │   └── get_flashcards_test.dart
│   │   └── entities/
│   │       └── flashcard_test.dart
│   └── data/
│       ├── models/
│       │   └── flashcard_model_test.dart
│       ├── datasources/
│       │   └── flashcard_local_datasource_test.dart
│       └── repositories/
│           └── flashcard_repository_test.dart
├── widget/
│   ├── atoms/
│   │   └── app_button_test.dart
│   ├── molecules/
│   │   └── flashcard_item_test.dart
│   └── pages/
│       └── home_page_test.dart
├── integration/
│   └── flashcard_flow_test.dart
└── mocks/
    └── mocks.dart
```

## Test Naming

**File naming:** `<source>_test.dart`
```dart
flashcard_store_test.dart  ✅
flashcard_test.dart        ✅
```

**Test names:** descriptive, snake_case
```dart
test('should_ReturnFlashcard_When_GivenValidId') { }  ✅
test('returns flashcard') { }                         ❌
```

**Test group names:**
```dart
group('GetFlashcards', () {
  // Tests for this use case
});

group('FlashcardStore', () {
  // Tests for this store
});
```

## Test Structure: AAA Pattern

All tests follow Arrange → Act → Assert:

```dart
test('should_ReturnFlashcard_When_IdExists', () async {
  // Arrange
  const id = '123';
  final expectedFlashcard = Flashcard(id: id, front: 'Test');
  when(mockRepository.getById(id))
      .thenAnswer((_) async => Right(expectedFlashcard));

  // Act
  final result = await usecase(GetFlashcardParams(id: id));

  // Assert
  expect(result, Right(expectedFlashcard));
  verify(mockRepository.getById(id)).called(1);
});
```

## Unit Tests - Domain Layer

100% coverage target - test all use cases and business logic:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fliplearnai/domain/usecases/get_flashcards.dart';

// Mock class
class MockFlashcardRepository extends Mock implements FlashcardRepository {}

void main() {
  late GetFlashcards usecase;
  late MockFlashcardRepository mockRepository;

  setUp(() {
    mockRepository = MockFlashcardRepository();
    usecase = GetFlashcards(mockRepository);
  });

  group('GetFlashcards', () {
    final tFlashcards = [
      const Flashcard(
        id: '1',
        front: 'Test Front',
        back: 'Test Back',
      ),
    ];

    test('should_ReturnFlashcards_When_RepositorySucceeds', () async {
      // Arrange
      when(mockRepository.getAll())
          .thenAnswer((_) async => Right(tFlashcards));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tFlashcards));
      verify(mockRepository.getAll()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should_ReturnFailure_When_RepositoryFails', () async {
      // Arrange
      final tFailure = CacheFailure('No data');
      when(mockRepository.getAll())
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Left(tFailure));
      verify(mockRepository.getAll()).called(1);
    });

    test('should_ReturnEmpty_When_NoFlashcardsExist', () async {
      // Arrange
      when(mockRepository.getAll())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right([]));
    });
  });
}
```

## Unit Tests - Data Layer

90%+ coverage - test repositories and data sources:

```dart
void main() {
  late FlashcardRepositoryImpl repository;
  late MockFlashcardLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockFlashcardLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FlashcardRepositoryImpl(
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('FlashcardRepositoryImpl', () {
    group('getAll', () {
      final tModels = [
        const FlashcardModel(id: '1', front: 'F', back: 'B'),
      ];
      final tEntities = tModels.map((m) => m.toEntity()).toList();

      test('should_ReturnCachedData_When_DeviceIsOffline', () async {
        // Arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);
        when(mockLocalDataSource.getFlashcards())
            .thenAnswer((_) async => tModels);

        // Act
        final result = await repository.getAll();

        // Assert
        verify(mockNetworkInfo.isConnected);
        verify(mockLocalDataSource.getFlashcards());
        expect(result, Right(tEntities));
      });

      test('should_CacheData_When_FetchedFromRemote', () async {
        // Arrange
        when(mockNetworkInfo.isConnected)
            .thenAnswer((_) async => true);
        when(mockLocalDataSource.getFlashcards())
            .thenAnswer((_) async => tModels);

        // Act
        final result = await repository.getAll();

        // Assert
        verify(mockLocalDataSource.getFlashcards());
        expect(result, Right(tEntities));
      });

      test('should_ReturnFailure_When_LocalDataSourceFails', () async {
        // Arrange
        when(mockLocalDataSource.getFlashcards())
            .thenThrow(CacheException('Cache error'));

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isA<Left>());
      });
    });
  });
}
```

## Widget Tests - Presentation Layer

70%+ coverage - test UI components and interactions:

```dart
void main() {
  group('AppButton', () {
    testWidgets('should_ShowLoadingIndicator_When_IsLoadingTrue',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Test',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should_CallOnPressed_When_Tapped',
        (WidgetTester tester) async {
      // Arrange
      var wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Test',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(AppButton));

      // Assert
      expect(wasPressed, true);
    });
  });

  group('HomePage', () {
    late MockFlashcardStore mockStore;

    setUp(() {
      mockStore = MockFlashcardStore();
    });

    Widget _createWidgetUnderTest() {
      return MaterialApp(
        home: Provider<FlashcardStore>.value(
          value: mockStore,
          child: const HomePage(),
        ),
      );
    }

    testWidgets('should_ShowLoadingIndicator_When_LoadingIsTrue',
        (WidgetTester tester) async {
      // Arrange
      when(mockStore.isLoading).thenReturn(true);
      when(mockStore.flashcards).thenReturn(ObservableList());

      // Act
      await tester.pumpWidget(_createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should_ShowFlashcardList_When_DataIsLoaded',
        (WidgetTester tester) async {
      // Arrange
      final flashcard = Flashcard(
        id: '1',
        front: 'Test',
        back: 'Back',
      );
      when(mockStore.isLoading).thenReturn(false);
      when(mockStore.flashcards)
          .thenReturn(ObservableList.of([flashcard]));

      // Act
      await tester.pumpWidget(_createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should_ShowErrorMessage_When_ErrorOccurs',
        (WidgetTester tester) async {
      // Arrange
      when(mockStore.isLoading).thenReturn(false);
      when(mockStore.errorMessage).thenReturn('An error occurred');
      when(mockStore.flashcards).thenReturn(ObservableList());

      // Act
      await tester.pumpWidget(_createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('An error occurred'), findsOneWidget);
    });
  });
}
```

## Integration Tests

Test complete user flows from start to finish:

```dart
void main() {
  group('FlashcardFlow', () {
    testWidgets('should_CreateAndViewFlashcard',
        (WidgetTester tester) async {
      // Start app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify home page is shown
      expect(find.text('My Flashcards'), findsOneWidget);

      // Tap create button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter flashcard data
      await tester.enterText(
        find.byKey(const Key('front_input')),
        'Test Front',
      );
      await tester.enterText(
        find.byKey(const Key('back_input')),
        'Test Back',
      );

      // Save flashcard
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      // Verify flashcard appears in list
      expect(find.text('Test Front'), findsOneWidget);

      // Tap flashcard to view details
      await tester.tap(find.text('Test Front'));
      await tester.pumpAndSettle();

      // Verify detail page shows all data
      expect(find.text('Test Back'), findsOneWidget);

      // Verify flip animation works
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.text('Test Front'), findsNothing);
    });
  });
}
```

## MobX Store Tests

Test observable state and actions:

```dart
void main() {
  group('FlashcardStore', () {
    late FlashcardStore store;
    late MockGetFlashcards mockGetFlashcards;
    late MockCreateFlashcard mockCreateFlashcard;

    setUp(() {
      mockGetFlashcards = MockGetFlashcards();
      mockCreateFlashcard = MockCreateFlashcard();
      store = FlashcardStore(
        mockGetFlashcards,
        mockCreateFlashcard,
      );
    });

    test('should_UpdateIsLoading_When_LoadingFlashcards', () async {
      // Arrange
      final flashcard = Flashcard(id: '1', front: 'Test', back: 'Back');
      when(mockGetFlashcards(NoParams()))
          .thenAnswer((_) async => Right([flashcard]));

      // Act
      expect(store.isLoading, false);
      store.loadFlashcards();
      expect(store.isLoading, true);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(store.isLoading, false);
      expect(store.flashcards.length, 1);
    });

    test('should_UpdateErrorMessage_When_LoadingFails', () async {
      // Arrange
      when(mockGetFlashcards(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      store.loadFlashcards();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(store.errorMessage, 'Error');
      expect(store.flashcards.isEmpty, true);
    });

    test('should_ComputeFavoritesCorrectly', () {
      // Arrange
      final flashcards = ObservableList.of([
        Flashcard(id: '1', front: 'F1', back: 'B1', isFavorite: true),
        Flashcard(id: '2', front: 'F2', back: 'B2', isFavorite: false),
        Flashcard(id: '3', front: 'F3', back: 'B3', isFavorite: true),
      ]);
      store.flashcards = flashcards;

      // Assert
      expect(store.favorites.length, 2);
      expect(store.favorites[0].id, '1');
      expect(store.favorites[1].id, '3');
    });
  });
}
```

## Mocking Best Practices

### Create Mocks Using Mockito
```dart
// For classes in same package
class MockFlashcardRepository extends Mock
    implements FlashcardRepository {}

// Generate mocks automatically (if using build_runner)
@GenerateMocks([FlashcardRepository])
void main() { }
```

### Setup Method Chains
```dart
when(mockRepository.getById(any))
    .thenAnswer((_) async => Right(flashcard));

when(mockRepository.getById('invalid'))
    .thenAnswer((_) async => Left(NotFoundFailure('Not found')));
```

### Verify Interactions
```dart
// Verify called once
verify(mockRepository.getById('1')).called(1);

// Verify never called
verifyNever(mockRepository.create(any));

// Verify no other interactions
verifyNoMoreInteractions(mockRepository);
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/unit/domain/usecases/get_flashcards_test.dart

# Run with pattern matching
flutter test --name="should_Return"

# Run widget tests
flutter test test/widget/

# Run integration tests
flutter test integration_test/

# Generate coverage report (HTML)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check coverage percentage
lcov --summary coverage/lcov.info
```

## Coverage Enforcement

The CI pipeline will:
1. Run all tests
2. Collect coverage data
3. Fail if coverage < 80%
4. Generate coverage report

Local checks:
```bash
# Before committing
flutter test --coverage
lcov --summary coverage/lcov.info
```

## Test Maintenance

### When to Refactor Tests
- After refactoring source code
- When test becomes hard to understand
- When multiple tests repeat setup code (extract helpers)

### Common Mistakes
- ❌ Testing implementation details instead of behavior
- ❌ Not mocking external dependencies
- ❌ Tests that are too tightly coupled to UI details
- ❌ Mixing multiple concerns in one test
- ❌ Not naming tests descriptively
- ❌ Over-testing (too many assertions per test)

### Best Practices
- ✅ One assertion per test when possible
- ✅ Mock all external dependencies
- ✅ Use descriptive test names
- ✅ Keep tests fast and independent
- ✅ Focus on behavior, not implementation
- ✅ Use fixtures for common test data

## Resources

- Flutter Testing: https://flutter.dev/docs/testing
- Mockito: https://pub.dev/packages/mockito
- Test Best Practices: https://flutter.dev/docs/testing/testing-reference
