# Code Style & Conventions

## Naming Conventions

### Files
```dart
// snake_case for all files
flashcard.dart              ✅
flashcard_store.dart        ✅
flashcard_repository.dart   ✅

// Not PascalCase
FlashcardStore.dart         ❌
```

### Classes, Enums, Typedefs
```dart
// PascalCase
class Flashcard { }
enum Status { active, inactive }
typedef OnFlashcardSelected = Function(Flashcard);

// Not camelCase
class flashcard { }       ❌
enum status { }           ❌
```

### Variables, Parameters, Methods
```dart
// camelCase
String userName;
int numberOfCards;
void loadFlashcards() { }
Future<void> generateWithAI() { }

// Not snake_case or PascalCase
String user_name;         ❌
int NumberOfCards;        ❌
void LoadFlashcards() { }  ❌
```

### Constants
```dart
// camelCase (even in Dart, unlike some other languages)
const String apiKey = 'key';
const int maxRetries = 3;
const Duration timeout = Duration(seconds: 30);

// Not SCREAMING_SNAKE_CASE
const String API_KEY = 'key';        ❌
```

### Private Members
```dart
// Use leading underscore
class FlashcardStore {
  final String _apiKey;
  late HiveBox<FlashcardModel> _box;

  void _validateInput(String input) { }
}
```

### Use Case & Repository Classes
```dart
// Verb + Noun pattern for use cases
class GetFlashcards { }           ✅
class CreateFlashcard { }         ✅
class UpdateFlashcard { }         ✅
class GenerateFlashcardWithAI { } ✅

// Noun + Repository pattern for repositories
abstract class FlashcardRepository { }
class FlashcardRepositoryImpl { }
```

## Formatting

### Line Length
- Maximum 80 characters (strict for Dart)
- Use `.` wrapping for long method chains

```dart
// Good
final result = flashcards
    .where((card) => card.isFavorite)
    .map((card) => card.front)
    .toList();

// Avoid
final result = flashcards.where((card) => card.isFavorite).map((card) => card.front).toList();
```

### Indentation
- 2 spaces (Dart standard)
- Never tabs

```dart
class Flashcard {
  final String front;

  const Flashcard({
    required this.front,
  });
}
```

### Spacing
- One blank line between methods in a class
- One blank line between top-level declarations
- No extra blank lines

```dart
class FlashcardStore {
  @observable
  bool isLoading = false;

  @action
  Future<void> load() async { }

  @action
  Future<void> create(Flashcard card) async { }
}
```

### Imports
- Order: dart, package, relative
- Sort each group alphabetically

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/entities/flashcard.dart';
import 'widgets/flashcard_item.dart';
```

## Comments

### Code Comments
- Explain WHY, not WHAT (code shows what)
- Use `///` for public API documentation
- Use `//` for inline comments

```dart
/// Returns list of flashcards from cache.
///
/// Throws [CacheException] if cache is corrupted.
Future<List<Flashcard>> getFlashcards() async {
  // Order by creation date, newest first
  return flashcards.reversed.toList();
}
```

### Documentation Comments
```dart
/// Generates a flashcard using AI based on input word.
///
/// Takes a word in Portuguese or English and returns a complete
/// flashcard with translation, examples, and pronunciation.
///
/// Parameters:
///   - word: The input word (PT or EN)
///   - provider: AI provider (claude or openai)
///
/// Returns a [Flashcard] with all fields populated by AI.
Future<Flashcard> generateWithAI(String word, String provider) async {
  // ...
}
```

## Types & Generics

### Use Explicit Types
```dart
// Good
final List<Flashcard> cards = [];
final Map<String, int> counts = {};

// Avoid (implicit types)
var cards = <Flashcard>[];
final counts = <String, int>{};
```

### Const Constructors
- Use `const` for immutable widgets and objects

```dart
const AppButton(
  label: 'Save',
  onPressed: _saveFlashcard,
)

class Flashcard {
  final String id;

  const Flashcard({required this.id});  // ✅ const constructor
}
```

## Null Safety

### Use Non-Null by Default
```dart
// Good - non-null by default
class Flashcard {
  final String id;           // Non-null
  final String? example;     // Explicitly nullable
}

// Handle nullable with null-coalescing
String getExample() => example ?? 'No example';

// Or use null-awareness
final upper = example?.toUpperCase();
```

### Late Variables
```dart
// For variables initialized after declaration
late Box<FlashcardModel> _box;

void initialize() {
  _box = Hive.box('flashcards');
}
```

## Class Structure

### Order of Class Members
1. Static constants
2. Static methods
3. Instance variables
4. Constructors
5. Methods
6. Getters/Setters
7. Operators (if any)

```dart
class FlashcardStore with Store {
  static const String storeName = 'flashcards';
  static const Duration timeout = Duration(seconds: 30);

  late Box<FlashcardModel> _box;

  @observable
  ObservableList<Flashcard> flashcards = ObservableList();

  FlashcardStore(this._box);

  @action
  Future<void> loadFlashcards() async { }

  @computed
  List<Flashcard> get favorites =>
    flashcards.where((c) => c.isFavorite).toList();
}
```

## Dart Best Practices

### Avoid Function Typedefs in Parameters
```dart
// Good - use modern syntax
typedef OnCardSelected = void Function(Flashcard);

// Avoid old style
void onCardTap(void Function(Flashcard) callback) { }
```

### Use Sealed Classes for Type Safety
```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}
```

### Prefer Composition Over Inheritance
```dart
// Good - composition
class FlashcardStore {
  final FlashcardRepository repository;
  FlashcardStore(this.repository);
}

// Less preferred - deep inheritance
class FeatureStore extends BaseStore { }
```

## Flutter-Specific

### Widget Naming
```dart
// Prefer descriptive names
class FlashcardListView extends StatelessWidget { }
class AIGenerationPanel extends StatefulWidget { }

// Avoid generic names
class MyWidget extends StatelessWidget { }
```

### BuildContext Usage
```dart
// Use context-aware methods
ScaffoldMessenger.of(context).showSnackBar(snackBar);
Navigator.of(context).push(route);

// Not global singletons for navigation when possible
```

### Key Usage
```dart
// Use Keys for identifiable widgets
Container(key: ValueKey(flashcard.id))
ListView(key: PageStorageKey('flashcards'))
```

## Linting Rules

All code must pass:
```bash
flutter analyze
dart format --set-exit-if-changed .
```

Configure in `analysis_options.yaml`:
- Base: very_good_analysis
- Strict mode: true
- Lines up to 80 characters
- All warnings must be fixed

## Avoid Anti-Patterns

### Don't Use Dynamic
```dart
// Bad
dynamic card = getFlashcard();

// Good
Flashcard? card = getFlashcard();
```

### Don't Suppress Analysis
```dart
// Bad - never do this
// ignore: prefer_const_constructors
Container(child: Text('Avoid'))

// Good - fix the issue instead
const Container(child: Text('Good'))
```

### Don't Use as Everywhere
```dart
// Bad
(json['flashcards'] as List).map((card) => Flashcard.fromJson(card));

// Good
final List<dynamic> flashcardsJson = json['flashcards'] ?? [];
flashcardsJson.whereType<Map<String, dynamic>>().map(...);
```

## Git Commit Message Format

Follow Conventional Commits:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code refactoring
- `test:` test additions/changes
- `docs:` documentation
- `chore:` tooling, dependencies

Example:
```
feat(flashcard): add AI generation for flashcards

Integrate Anthropic Claude API to generate complete flashcards
from user input word. Includes example sentences and pronunciation.

Closes #123
```

## Auto-Formatting

Enable auto-format on save in your IDE:
```json
// .vscode/settings.json
{
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.formatOnSave": true
  }
}
```

Or manually:
```bash
dart format . --fix
```
