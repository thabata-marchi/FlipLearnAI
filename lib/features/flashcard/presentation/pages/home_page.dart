import 'package:fliplearnai/features/flashcard/presentation/molecules/error_message.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/search_bar.dart';
import 'package:fliplearnai/features/flashcard/presentation/organisms/flashcard_list.dart';
import 'package:fliplearnai/features/flashcard/presentation/pages/create_flashcard_page.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipLearnAI'),
        elevation: 0,
        actions: [
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
                  onFlashcardTap: (id) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Detail page coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onFavoriteToggle: _store.toggleFavorite,
                  onDelete: _store.deleteFlashcard,
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
