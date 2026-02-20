import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/error_message.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/search_bar.dart';
import 'package:fliplearnai/features/flashcard/presentation/organisms/flashcard_list.dart';
import 'package:fliplearnai/features/flashcard/presentation/pages/create_flashcard_page.dart';
import 'package:fliplearnai/features/flashcard/presentation/pages/flashcard_detail_page.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

export 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart'
    show FlashcardSortOption;

/// HomePage for FlipLearnAI
///
/// Main screen displaying flashcards with search functionality
class HomePage extends StatefulWidget {
  /// Constructor
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FlashcardStore _store;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<FlashcardStore>();
    _store.loadFlashcards();
  }

  void _handleFABPress() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CreateFlashcardPage(),
      ),
    ).then((_) {
      // Reload flashcards when returning from creation
      _store.loadFlashcards();
    });
  }

  void _handleEditFlashcard(Flashcard flashcard) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => FlashcardDetailPage(flashcard: flashcard),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Observer(
        builder: (_) => Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...FlashcardSortOption.values.map((option) {
                final isSelected = _store.sortOption == option;
                return ListTile(
                  leading: Icon(
                    _getSortIcon(option),
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    _store.setSortOption(option);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSortIcon(FlashcardSortOption option) {
    switch (option) {
      case FlashcardSortOption.newestFirst:
        return Icons.schedule;
      case FlashcardSortOption.oldestFirst:
        return Icons.history;
      case FlashcardSortOption.alphabeticalAZ:
        return Icons.sort_by_alpha;
      case FlashcardSortOption.alphabeticalZA:
        return Icons.sort_by_alpha;
      case FlashcardSortOption.favoritesFirst:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipLearnAI'),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) => IconButton(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort (${_store.sortOption.label})',
              onPressed: _showSortOptions,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBar(
                  onChanged: _store.setSearchQuery,
                  onClear: () => _store.setSearchQuery(''),
                ),
              ),
              if (_store.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ErrorMessage(
                    message: _store.errorMessage!,
                    onRetry: _store.loadFlashcards,
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: FlashcardList(
                  flashcards: _store.filteredFlashcards,
                  isLoading: _store.isLoading,
                  onFavoriteToggle: _store.toggleFavorite,
                  onDelete: _store.deleteFlashcard,
                  onEdit: _handleEditFlashcard,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFABPress,
        child: const Icon(Icons.add),
      ),
    );
  }
}
