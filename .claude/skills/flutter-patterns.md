# Flutter Patterns & Best Practices

Padrões específicos do Flutter para o projeto FlipLearnAI.

## Widget Patterns

### Stateless vs Stateful

**Use StatelessWidget quando:**
- Widget não precisa de estado interno
- Depende apenas de props (parâmetros do construtor)
- Usa MobX Observer para reatividade

```dart
// ✅ Correto - StatelessWidget com Observer
class FlashcardList extends StatelessWidget {
  const FlashcardList({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FlashcardStore>(context);
    
    return Observer(
      builder: (_) => ListView.builder(
        itemCount: store.flashcards.length,
        itemBuilder: (context, index) => FlashcardItem(
          flashcard: store.flashcards[index],
        ),
      ),
    );
  }
}
```

**Use StatefulWidget quando:**
- Precisa de estado local (animações, controllers)
- Gerencia TextEditingController, AnimationController
- Estado é interno ao widget (não compartilhado)

```dart
// ✅ Correto - StatefulWidget para animação local
class FlipCard extends StatefulWidget {
  final String frontText;
  final String backText;

  const FlipCard({
    super.key,
    required this.frontText,
    required this.backText,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ...
}
```

### Const Constructors

**Sempre use `const` quando possível:**

```dart
// ✅ Correto
const SizedBox(height: 16);
const EdgeInsets.all(16);
const Text('Hello');

// ❌ Evitar
SizedBox(height: 16);
EdgeInsets.all(16);
```

**Widgets com const constructor:**

```dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppButton({  // ✅ const constructor
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

### Widget Keys

**Quando usar Keys:**

```dart
// ✅ ListView com items dinâmicos
ListView.builder(
  itemCount: flashcards.length,
  itemBuilder: (context, index) => FlashcardItem(
    key: ValueKey(flashcards[index].id),  // ✅ Key única
    flashcard: flashcards[index],
  ),
);

// ✅ AnimatedSwitcher precisa de key
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text(
    message,
    key: ValueKey(message),  // ✅ Muda quando message muda
  ),
);

// ✅ Form fields
TextFormField(
  key: const Key('email_field'),  // ✅ Para testes
);
```

## MobX + Provider Patterns

### Store Setup

```dart
// flashcard_store.dart
import 'package:mobx/mobx.dart';

part 'flashcard_store.g.dart';

class FlashcardStore = _FlashcardStoreBase with _$FlashcardStore;

abstract class _FlashcardStoreBase with Store {
  final GetFlashcards _getFlashcardsUseCase;
  final CreateFlashcard _createFlashcardUseCase;
  final GenerateFlashcardWithAI _generateWithAIUseCase;

  _FlashcardStoreBase({
    required GetFlashcards getFlashcardsUseCase,
    required CreateFlashcard createFlashcardUseCase,
    required GenerateFlashcardWithAI generateWithAIUseCase,
  })  : _getFlashcardsUseCase = getFlashcardsUseCase,
        _createFlashcardUseCase = createFlashcardUseCase,
        _generateWithAIUseCase = generateWithAIUseCase;

  // ===== OBSERVABLES =====
  
  @observable
  ObservableList<Flashcard> flashcards = ObservableList<Flashcard>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  Flashcard? selectedFlashcard;

  // ===== COMPUTED =====

  @computed
  List<Flashcard> get favorites =>
      flashcards.where((card) => card.isFavorite).toList();

  @computed
  int get totalCount => flashcards.length;

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get isEmpty => flashcards.isEmpty && !isLoading;

  // ===== ACTIONS =====

  @action
  Future<void> loadFlashcards() async {
    isLoading = true;
    errorMessage = null;

    final result = await _getFlashcardsUseCase(NoParams());
    
    result.fold(
      (failure) => errorMessage = failure.message,
      (cards) => flashcards = ObservableList.of(cards),
    );

    isLoading = false;
  }

  @action
  Future<void> createFlashcard(Flashcard flashcard) async {
    isLoading = true;
    errorMessage = null;

    final result = await _createFlashcardUseCase(
      CreateFlashcardParams(flashcard: flashcard),
    );

    result.fold(
      (failure) => errorMessage = failure.message,
      (created) => flashcards.add(created),
    );

    isLoading = false;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void selectFlashcard(Flashcard? card) {
    selectedFlashcard = card;
  }
}
```

### Provider Setup

```dart
// main.dart
void main() {
  setupDependencies();  // GetIt setup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlashcardStore>(
          create: (_) => getIt<FlashcardStore>(),
        ),
        Provider<AIConfigStore>(
          create: (_) => getIt<AIConfigStore>(),
        ),
      ],
      child: MaterialApp(
        title: 'FlipLearnAI',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
```

### Observer Usage

```dart
// ✅ Correto - Observer granular
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FlashcardStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipLearnAI'),
        actions: [
          // ✅ Observer apenas no que muda
          Observer(
            builder: (_) => Badge(
              label: Text('${store.totalCount}'),
              child: const Icon(Icons.bookmark),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.hasError) {
            return ErrorMessage(
              message: store.errorMessage!,
              onRetry: store.loadFlashcards,
            );
          }

          if (store.isEmpty) {
            return const EmptyState(
              icon: Icons.school,
              title: 'Nenhum flashcard',
              description: 'Crie seu primeiro flashcard!',
            );
          }

          return FlashcardList(flashcards: store.flashcards);
        },
      ),
    );
  }
}
```

### Reaction for Side Effects

```dart
class _HomePageState extends State<HomePage> {
  late FlashcardStore _store;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    super.initState();
    _store = Provider.of<FlashcardStore>(context, listen: false);
    
    _disposers = [
      // ✅ Reaction para mostrar snackbar em erro
      reaction(
        (_) => _store.errorMessage,
        (String? error) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
      ),
      // ✅ AutoRun para logging
      autorun((_) {
        debugPrint('Flashcards count: ${_store.totalCount}');
      }),
    ];

    // Load initial data
    _store.loadFlashcards();
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
    super.dispose();
  }
}
```

## Navigation Patterns

### GoRouter Setup

```dart
// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/flashcard/:id',
      name: 'flashcard_detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FlashcardDetailPage(flashcardId: id);
      },
    ),
    GoRoute(
      path: '/create',
      name: 'create_flashcard',
      builder: (context, state) => const CreateFlashcardPage(),
    ),
    GoRoute(
      path: '/generate',
      name: 'ai_generate',
      builder: (context, state) => const AIGeneratePage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/settings/api',
      name: 'api_settings',
      builder: (context, state) => const APISettingsPage(),
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(error: state.error),
);
```

### Navigation Usage

```dart
// ✅ Named routes (preferido)
context.goNamed('flashcard_detail', pathParameters: {'id': flashcard.id});
context.goNamed('home');

// ✅ Push para pilha de navegação
context.pushNamed('create_flashcard');

// ✅ Pop para voltar
context.pop();

// ✅ Com query parameters
context.goNamed(
  'ai_generate',
  queryParameters: {'word': 'example'},
);
```

## Form Patterns

### Form Validation

```dart
class CreateFlashcardForm extends StatefulWidget {
  final Function(Flashcard) onSubmit;

  const CreateFlashcardForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CreateFlashcardForm> createState() => _CreateFlashcardFormState();
}

class _CreateFlashcardFormState extends State<CreateFlashcardForm> {
  final _formKey = GlobalKey<FormState>();
  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final flashcard = Flashcard(
        id: const Uuid().v4(),
        front: _frontController.text.trim(),
        back: _backController.text.trim(),
      );
      widget.onSubmit(flashcard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('front_field'),
            controller: _frontController,
            decoration: const InputDecoration(
              labelText: 'Frente (Português)',
              hintText: 'Digite a palavra em português',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }
              if (value.trim().length < 2) {
                return 'Mínimo 2 caracteres';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('back_field'),
            controller: _backController,
            decoration: const InputDecoration(
              labelText: 'Verso (Inglês)',
              hintText: 'Digite a tradução em inglês',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Criar Flashcard',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
```

## Animation Patterns

### Implicit Animations

```dart
// ✅ AnimatedContainer para transições suaves
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  padding: isExpanded 
      ? const EdgeInsets.all(24) 
      : const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isSelected ? Colors.blue.shade50 : Colors.white,
    borderRadius: BorderRadius.circular(isExpanded ? 16 : 8),
  ),
  child: content,
);

// ✅ AnimatedOpacity para fade
AnimatedOpacity(
  duration: const Duration(milliseconds: 200),
  opacity: isVisible ? 1.0 : 0.0,
  child: child,
);

// ✅ AnimatedSwitcher para trocar widgets
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  transitionBuilder: (child, animation) => FadeTransition(
    opacity: animation,
    child: child,
  ),
  child: Text(
    message,
    key: ValueKey(message),
  ),
);
```

### Explicit Animations (Flip Card)

```dart
class FlipCardAnimation extends StatefulWidget {
  final Widget front;
  final Widget back;

  const FlipCardAnimation({
    super.key,
    required this.front,
    required this.back,
  });

  @override
  State<FlipCardAnimation> createState() => _FlipCardAnimationState();
}

class _FlipCardAnimationState extends State<FlipCardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _showFront = !_showFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14159;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: _animation.value < 0.5
                ? widget.front
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}
```

## Theming Patterns

### Theme Setup

```dart
// lib/core/theme/app_theme.dart
abstract class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    // ... dark theme customizations
  );
}
```

### Theme Extensions

```dart
// Custom colors extension
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color warning;
  final Color info;

  const AppColors({
    required this.success,
    required this.warning,
    required this.info,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// Usage
final colors = Theme.of(context).extension<AppColors>()!;
Container(color: colors.success);
```

## Error Handling Patterns

### Error Boundary Widget

```dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stack)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      setState(() {
        _error = details.exception;
        _stackTrace = details.stack;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          Center(
            child: Text('Error: $_error'),
          );
    }
    return widget.child;
  }
}
```

### Async Error Handling

```dart
// ✅ FutureBuilder com tratamento completo
FutureBuilder<List<Flashcard>>(
  future: _loadFlashcards(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return ErrorMessage(
        message: snapshot.error.toString(),
        onRetry: () => setState(() {}),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const EmptyState(
        title: 'Nenhum flashcard',
      );
    }

    return FlashcardList(flashcards: snapshot.data!);
  },
);
```

## Performance Patterns

### ListView Optimization

```dart
// ✅ Use ListView.builder para listas grandes
ListView.builder(
  itemCount: flashcards.length,
  itemBuilder: (context, index) => FlashcardItem(
    key: ValueKey(flashcards[index].id),
    flashcard: flashcards[index],
  ),
);

// ✅ Use itemExtent se altura for fixa
ListView.builder(
  itemCount: flashcards.length,
  itemExtent: 80,  // Altura fixa = melhor performance
  itemBuilder: (context, index) => FlashcardItem(
    flashcard: flashcards[index],
  ),
);

// ✅ Use cacheExtent para pré-carregar
ListView.builder(
  cacheExtent: 500,  // Pré-carrega 500px além da viewport
  itemCount: flashcards.length,
  itemBuilder: (context, index) => FlashcardItem(
    flashcard: flashcards[index],
  ),
);
```

### Const Widgets & RepaintBoundary

```dart
// ✅ Extraia widgets const
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _HomeAppBar(),  // ✅ Widget const separado
      body: Observer(
        builder: (_) => _buildBody(),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('FlipLearnAI'),
    );
  }
}

// ✅ RepaintBoundary para animações isoladas
RepaintBoundary(
  child: FlipCardAnimation(
    front: frontWidget,
    back: backWidget,
  ),
);
```

## Testing Patterns

### Widget Test Setup

```dart
void main() {
  group('FlashcardItem', () {
    late MockFlashcardStore mockStore;

    setUp(() {
      mockStore = MockFlashcardStore();
    });

    Widget createWidgetUnderTest({required Flashcard flashcard}) {
      return MaterialApp(
        home: Provider<FlashcardStore>.value(
          value: mockStore,
          child: Scaffold(
            body: FlashcardItem(
              flashcard: flashcard,
              onTap: () {},
              onFavoriteToggle: (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('should display front text', (tester) async {
      // Arrange
      final flashcard = Flashcard(
        id: '1',
        front: 'Hello',
        back: 'Olá',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(flashcard: flashcard));

      // Assert
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      var wasTapped = false;
      final flashcard = Flashcard(id: '1', front: 'Test', back: 'Teste');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlashcardItem(
              flashcard: flashcard,
              onTap: () => wasTapped = true,
              onFavoriteToggle: (_) {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(FlashcardItem));

      // Assert
      expect(wasTapped, true);
    });
  });
}
```

## Resources

- Flutter Documentation: https://docs.flutter.dev
- MobX Flutter: https://mobx.netlify.app/getting-started
- GoRouter: https://pub.dev/packages/go_router
- Provider: https://pub.dev/packages/provider
- Flutter Performance: https://docs.flutter.dev/perf/best-practices