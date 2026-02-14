import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/organisms/flip_card.dart';
import 'package:fliplearnai/features/flashcard/presentation/pages/edit_flashcard_page.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

/// Page for viewing and interacting with a single flashcard
///
/// Displays the flashcard with flip animation and options to
/// toggle favorite status and delete the card.
class FlashcardDetailPage extends StatefulWidget {
  /// Constructor
  const FlashcardDetailPage({
    required this.flashcard,
    super.key,
  });

  /// The flashcard to display
  final Flashcard flashcard;

  @override
  State<FlashcardDetailPage> createState() => _FlashcardDetailPageState();
}

class _FlashcardDetailPageState extends State<FlashcardDetailPage> {
  late final FlashcardStore _store;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<FlashcardStore>();
  }

  void _handleToggleFavorite() {
    _store.toggleFavorite(widget.flashcard.id);
  }

  Future<void> _handleEdit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditFlashcardPage(flashcard: widget.flashcard),
      ),
    );

    // If the flashcard was updated, navigate back to refresh the list
    if ((result ?? false) && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleDelete() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text(
          'Are you sure you want to delete this flashcard? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _store.deleteFlashcard(widget.flashcard.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard'),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                widget.flashcard.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.flashcard.isFavorite ? Colors.red : null,
              ),
              onPressed: _handleToggleFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _handleEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _handleDelete,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 24,
            children: [
              FlipCard(
                frontText: widget.flashcard.front,
                backText: widget.flashcard.back,
                pronunciation: widget.flashcard.pronunciation,
                exampleText: widget.flashcard.example,
              ),
              Column(
                spacing: 12,
                children: [
                  if (widget.flashcard.pronunciation != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pronunciation',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.purple.shade700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.flashcard.pronunciation!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.flashcard.example != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Example Sentence',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.green.shade700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.flashcard.example!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.flashcard.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
