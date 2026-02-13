# FlipLearnAI 🚀

An AI-powered flashcard learning application built with Flutter and Clean Architecture. Learn languages faster with intelligent flashcard generation using Claude (Anthropic) or OpenAI.

![Flutter](https://img.shields.io/badge/Flutter-3.19.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

## ✨ Features

### Core Functionality
- ✅ **Manual Flashcard Creation** - Create flashcards without any API key
- 🎯 **30-50 Pre-loaded Flashcards** - Start learning immediately with Portuguese-English flashcards
- 🔄 **Flip Card Animation** - Smooth 3D flip animation to reveal translations
- ⭐ **Favorites** - Mark important flashcards for quick access
- 🔍 **Search** - Find flashcards by front, back, or example text
- ✏️ **Full CRUD** - Create, read, update, and delete flashcards
- 📱 **Offline-First** - All data stored locally with Hive

### AI-Powered Generation (Optional)
- 🤖 **AI Generation** - Generate complete flashcards from a single word
- 🔑 **BYOK (Bring Your Own Key)** - Use your own Claude or OpenAI API key
- 🌐 **Multi-Provider Support** - Choose between Claude (Anthropic) or OpenAI
- 💰 **Cost-Effective** - Only pay for what you use (~R$0.01-0.015 per flashcard)
- 🔒 **Secure Storage** - API keys stored with Flutter Secure Storage
- 🌍 **Bilingual** - Generate from Portuguese or English input

### Generated Flashcard Contents
When using AI generation, each flashcard includes:
- **Front/Back Translation** (PT ↔ EN)
- **Example Sentence** (in both languages)
- **Pronunciation Tips** (optional)
- **Usage Context** (formal/informal/etc)

## 📱 Screenshots

*Coming soon*

## 🏗️ Architecture

FlipLearnAI follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│           PRESENTATION LAYER                     │
│  (MobX Stores, Atomic Design Components)        │
└──────────────┬──────────────────────────────────┘
               │ depends on
┌──────────────▼──────────────────────────────────┐
│           DATA LAYER                             │
│  (Repositories, DataSources, Models)            │
└──────────────┬──────────────────────────────────┘
               │ depends on
┌──────────────▼──────────────────────────────────┐
│           DOMAIN LAYER                           │
│  (Entities, Use Cases, Interfaces)              │
└──────────────────────────────────────────────────┘
```

### Key Architectural Patterns

- **Clean Architecture** - Separation of business logic from UI and data
- **Atomic Design** - UI components organized as Atoms → Molecules → Organisms → Pages
- **MobX** - Reactive state management with stores
- **Either Pattern (dartz)** - Functional error handling
- **Dependency Injection** - GetIt for dependency management
- **Repository Pattern** - Abstract data access layer
- **Use Cases** - Single-responsibility business operations

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `>=3.19.0`
- Dart SDK: `>=3.3.0`
- iOS Simulator or Android Emulator (for testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fliplearnai.git
   cd fliplearnai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Using AI Features (Optional)

To use AI-powered flashcard generation:

1. Get an API key:
   - **Claude (Anthropic)**: [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys)
   - **OpenAI**: [platform.openai.com/api-keys](https://platform.openai.com/api-keys)

2. In the app:
   - Navigate to **Settings** → **API Configuration**
   - Select your provider (Claude or OpenAI)
   - Enter your API key
   - Save

3. Create flashcards with AI:
   - Tap the **+** FAB on home screen
   - Switch to **AI** tab
   - Enter a word (Portuguese or English)
   - Tap **Generate**

**Note**: The app works perfectly without an API key for manual flashcard creation.

## 📦 Tech Stack

### Core
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **MobX** - State management
- **GetIt** - Dependency injection
- **GoRouter** - Navigation

### Data & Persistence
- **Hive** - Local NoSQL database
- **Flutter Secure Storage** - Encrypted storage for API keys
- **Dio** - HTTP client for API calls

### Utilities
- **dartz** - Functional programming (Either, Option)
- **equatable** - Value equality
- **uuid** - Unique ID generation
- **intl** - Internationalization

### Development
- **build_runner** - Code generation
- **mobx_codegen** - MobX code generation
- **json_serializable** - JSON serialization
- **mockito** - Testing mocks
- **very_good_analysis** - Strict linting

## 📂 Project Structure

```
lib/
├── core/                      # Shared utilities
│   ├── di/                    # Dependency injection
│   ├── errors/                # Failures & exceptions
│   ├── network/               # Dio client, network info
│   ├── services/              # Secure storage
│   └── usecases/              # Base UseCase class
│
├── features/
│   ├── flashcard/             # Flashcard feature
│   │   ├── domain/            # Business logic
│   │   │   ├── entities/      # Flashcard entity
│   │   │   ├── repositories/  # Repository interfaces
│   │   │   └── usecases/      # Business operations
│   │   ├── data/              # Data layer
│   │   │   ├── models/        # FlashcardModel
│   │   │   ├── datasources/   # Local & AI datasources
│   │   │   └── repositories/  # Repository implementations
│   │   └── presentation/      # UI layer
│   │       ├── stores/        # MobX stores
│   │       ├── atoms/         # Basic components
│   │       ├── molecules/     # Composed components
│   │       ├── organisms/     # Complex sections
│   │       └── pages/         # Full screens
│   │
│   └── settings/              # Settings feature
│       └── presentation/
│           ├── stores/        # AIConfigStore
│           └── pages/         # API settings page
│
└── main.dart
```

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run with coverage
```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Generate HTML coverage report
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Targets
- **Domain Layer**: 100% (pure Dart, no dependencies)
- **Data Layer**: 90%+
- **Presentation Layer**: 70%+
- **Overall**: 80% minimum

## 🔒 Security & Privacy

- ✅ **No API key required** for basic functionality
- ✅ API keys stored with **Flutter Secure Storage** (encrypted)
- ✅ Keys stored in device Keychain (iOS) or EncryptedSharedPreferences (Android)
- ✅ No API keys logged or exposed
- ✅ All data stored locally on device
- ✅ No user tracking or analytics
- ✅ BYOK model - you control your AI costs

## 💰 Cost Information

AI generation costs (when using your own API key):

| Provider | Model | Cost per Flashcard | 100 Flashcards |
|----------|-------|--------------------|----------------|
| Claude (Anthropic) | Haiku | ~$0.003 (~R$0.015) | ~R$1.50 |
| OpenAI | GPT-3.5 Turbo | ~$0.002 (~R$0.01) | ~R$1.00 |

**Note**: Costs are estimates based on average token usage. You only pay for what you generate.

## 🛠️ Development

### Code Generation

After modifying models, stores, or serializable classes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Linting

```bash
flutter analyze
```

### Format Code

```bash
dart format . --fix
```

## 📝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing code style and architecture patterns
4. Write tests for new features
5. Ensure all tests pass (`flutter test`)
6. Run linter (`flutter analyze`)
7. Commit your changes (`git commit -m 'feat: add amazing feature'`)
8. Push to the branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Anthropic** - Claude API
- **OpenAI** - GPT API
- **Flutter Team** - Amazing framework
- **Clean Architecture** - Robert C. Martin
- **Atomic Design** - Brad Frost

## 📧 Contact

**Thabata Marchi**

- GitHub: [@thabatamarchi](https://github.com/thabatamarchi)
- Email: your.email@example.com

## 🗺️ Roadmap

- [ ] Spaced repetition algorithm
- [ ] Study sessions with statistics
- [ ] Export/Import flashcards
- [ ] Deck organization (categories/folders)
- [ ] Cloud sync (optional)
- [ ] Audio pronunciation
- [ ] Image support in flashcards
- [ ] Dark mode
- [ ] Multiple language pairs (not just PT-EN)
- [ ] Web version

---

Made with ❤️ using Flutter and Clean Architecture
