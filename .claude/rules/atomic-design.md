# Atomic Design Pattern for UI Components

## Overview

Atomic Design is a methodology for creating modular, scalable UI systems. Components are organized into a hierarchy from smallest to largest.

```
┌─────────────────────────────────┐
│     PAGES (Full Screens)        │
├─────────────────────────────────┤
│   ORGANISMS (Complex Sections)  │
├─────────────────────────────────┤
│  MOLECULES (Atom Combinations)  │
├─────────────────────────────────┤
│    ATOMS (Basic Building)       │
└─────────────────────────────────┘
```

## 1. ATOMS (Basic Building Blocks)

Smallest, most reusable components. Standalone, no business logic.

### Characteristics
- No dependencies on other components (except Flutter built-in)
- Pure presentation
- Highly reusable
- Accept configuration via constructor parameters

### Examples

#### AppButton
```dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double width;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}
```

#### AppTextField
```dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;

  const AppTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
```

#### AppCard
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double elevation;
  final Color? color;

  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      child: Padding(padding: padding, child: child),
    );
  }
}
```

#### AppText
```dart
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const AppText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
```

### Common Atoms
- `AppButton` (primary, secondary, text variants)
- `AppTextField` (with validation)
- `AppCard`
- `AppText` (standardized typography)
- `AppIcon` (consistent sizing)
- `AppDivider`
- `AppSpacing` (consistent gaps)
- `LoadingIndicator`
- `EmptyStateIcon`

## 2. MOLECULES (Atom Combinations)

Combination of atoms with simple logic. Still no business logic.

### Characteristics
- Combine multiple atoms
- May have simple state (focus, hover)
- Reusable across multiple pages
- Light presentation logic

### Examples

#### SearchBar
```dart
class SearchBar extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const SearchBar({
    Key? key,
    this.hint = 'Search...',
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                widget.onClear?.call();
              },
            ),
        ],
      ),
    );
  }
}
```

#### FlashcardItem
```dart
class FlashcardItem extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onTap;
  final ValueChanged<bool> onFavoriteToggle;

  const FlashcardItem({
    Key? key,
    required this.flashcard,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    flashcard.front,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    flashcard.back,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                flashcard.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () =>
                  onFavoriteToggle(!flashcard.isFavorite),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### ErrorMessage
```dart
class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.red[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red[700]),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(message),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'Retry',
              onPressed: onRetry!,
            ),
          ],
        ],
      ),
    );
  }
}
```

### Common Molecules
- `SearchBar`
- `FlashcardItem` (preview)
- `ErrorMessage`
- `EmptyState`
- `FormInput` (label + text field + error)
- `ListTile` (icon + text + action)
- `RatingStars`

## 3. ORGANISMS (Complex Sections)

Complex UI sections composed of molecules and atoms. Contains presentation logic.

### Characteristics
- Combine multiple molecules
- May contain simple presentation state
- No business logic (no use cases, no external dependencies)
- Still reusable (could be in multiple pages)

### Examples

#### FlashcardList
```dart
class FlashcardList extends StatelessWidget {
  final List<Flashcard> flashcards;
  final VoidCallback onFlashcardTap;
  final ValueChanged<String> onFlashcardDelete;
  final ValueChanged<String> onFavoriteTap;
  final bool isLoading;

  const FlashcardList({
    Key? key,
    required this.flashcards,
    required this.onFlashcardTap,
    required this.onFlashcardDelete,
    required this.onFavoriteTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (flashcards.isEmpty) {
      return EmptyState(
        icon: Icons.bookmark_outline,
        title: 'No Flashcards',
        description: 'Create your first flashcard to get started',
      );
    }

    return ListView.builder(
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        return FlashcardItem(
          flashcard: flashcard,
          onTap: () => onFlashcardTap(),
          onFavoriteToggle: (isFav) => onFavoriteTap(flashcard.id),
        );
      },
    );
  }
}
```

#### AIGenerationPanel
```dart
class AIGenerationPanel extends StatefulWidget {
  final ValueChanged<String> onGenerate;
  final bool isGenerating;
  final String? error;

  const AIGenerationPanel({
    Key? key,
    required this.onGenerate,
    this.isGenerating = false,
    this.error,
  }) : super(key: key);

  @override
  State<AIGenerationPanel> createState() => _AIGenerationPanelState();
}

class _AIGenerationPanelState extends State<AIGenerationPanel> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        spacing: 12,
        children: [
          AppText(
            'Generate with AI',
            style: context.textTheme.titleMedium,
          ),
          AppTextField(
            label: 'Word (PT or EN)',
            controller: _controller,
            hint: 'Enter a word to generate flashcard',
          ),
          if (widget.error != null)
            ErrorMessage(message: widget.error!),
          AppButton(
            label: 'Generate',
            isLoading: widget.isGenerating,
            onPressed: () => widget.onGenerate(_controller.text),
          ),
        ],
      ),
    );
  }
}
```

#### FlipCard
```dart
class FlipCard extends StatefulWidget {
  final String frontText;
  final String backText;

  const FlipCard({
    Key? key,
    required this.frontText,
    required this.backText,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
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
            child: AppCard(
              child: SizedBox(
                height: 200,
                child: Center(
                  child: angle > 1.5708
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.14159),
                          child: AppText(widget.backText),
                        )
                      : AppText(widget.frontText),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Common Organisms
- `FlashcardList`
- `AIGenerationPanel`
- `FlipCard`
- `Header` (with title, actions)
- `FloatingMenu`
- `Tabs`

## 4. TEMPLATES (Reusable Layouts)

Page templates that define layout structure. Used by multiple pages.

### Characteristics
- Define layout patterns (AppBar, body, bottom nav, FAB)
- Reusable across multiple screens
- Accept page-specific content as children

### Examples

#### MainLayout
```dart
class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final List<BottomNavigationBarItem>? bottomNavigationItems;
  final int? currentBottomIndex;
  final ValueChanged<int>? onBottomIndexChanged;

  const MainLayout({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.appBar,
    this.bottomNavigationItems,
    this.currentBottomIndex,
    this.onBottomIndexChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: Text(title)),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationItems != null
          ? BottomNavigationBar(
              items: bottomNavigationItems!,
              currentIndex: currentBottomIndex ?? 0,
              onTap: onBottomIndexChanged,
            )
          : null,
    );
  }
}
```

#### CardDetailLayout
```dart
class CardDetailLayout extends StatelessWidget {
  final String title;
  final Widget cardContent;
  final List<Widget> actions;

  const CardDetailLayout({
    Key? key,
    required this.title,
    required this.cardContent,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            cardContent,
            const SizedBox(height: 24),
            Row(
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 5. PAGES (Complete Screens)

Full screens that use templates, organisms, molecules, and atoms. Connected to stores and business logic.

### Characteristics
- Use templates for layout
- Connect to stores/state management
- Orchestrate complex interactions
- Handle navigation

### Structure

```
lib/features/flashcard/presentation/pages/
├── home_page.dart
├── flashcard_detail_page.dart
├── ai_generation_page.dart
└── settings_page.dart
```

## Component Hierarchy Rules

1. **Atoms CANNOT depend on:**
   - Molecules, Organisms, Pages
   - Business logic
   - External services

2. **Molecules CAN depend on:**
   - Atoms only
   - No Organisms, Pages

3. **Organisms CAN depend on:**
   - Atoms, Molecules
   - No Pages

4. **Pages CAN depend on:**
   - Everything else
   - Stores and business logic

## File Organization

```
lib/presentation/
├── atoms/
│   ├── app_button.dart
│   ├── app_card.dart
│   ├── app_text_field.dart
│   ├── app_text.dart
│   ├── app_icon.dart
│   ├── app_divider.dart
│   ├── loading_indicator.dart
│   └── empty_state_icon.dart
│
├── molecules/
│   ├── search_bar.dart
│   ├── flashcard_item.dart
│   ├── error_message.dart
│   ├── empty_state.dart
│   └── form_input.dart
│
├── organisms/
│   ├── flashcard_list.dart
│   ├── ai_generation_panel.dart
│   ├── flip_card.dart
│   └── header.dart
│
├── templates/
│   ├── main_layout.dart
│   └── card_detail_layout.dart
│
├── pages/
│   ├── home_page.dart
│   ├── flashcard_detail_page.dart
│   ├── ai_config_page.dart
│   └── settings_page.dart
│
└── stores/
    ├── flashcard_store.dart
    └── ai_config_store.dart
```

## Best Practices

1. **Keep Atoms Pure** - No logic, just presentation
2. **Compose Upward** - Build complexity from simple pieces
3. **Reuse Aggressively** - Extract common patterns into molecules
4. **Isolate State** - State lives at the lowest necessary level
5. **Single Responsibility** - Each component has one job
6. **Test Everything** - Atoms 100%, Molecules 80%, Organisms/Pages 70%

## Benefits

- ✅ Highly reusable components
- ✅ Easy to maintain and update
- ✅ Consistent design system
- ✅ Easy onboarding for new developers
- ✅ Scalable architecture
- ✅ Better performance (widget reuse)
