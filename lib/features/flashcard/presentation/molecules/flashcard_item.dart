import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/organisms/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// FlashcardItem molecule component
///
/// Displays a single flashcard with flip animation in a list
class FlashcardItem extends StatefulWidget {
  /// Constructor
  const FlashcardItem({
    required this.flashcard,
    required this.onFavoriteToggle,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  /// The flashcard to display
  final Flashcard flashcard;

  /// Callback when favorite icon is toggled
  final VoidCallback onFavoriteToggle;

  /// Callback when card is deleted
  final VoidCallback onDelete;

  /// Callback when edit icon is tapped (opens detail/edit)
  final VoidCallback onEdit;

  @override
  State<FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<FlashcardItem> {
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Future<bool> _confirmDismiss(DismissDirection direction) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text(
          'Are you sure you want to delete this flashcard? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.flashcard.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: _confirmDismiss,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: Column(
        spacing: 8,
        children: [
          FlipCard(
            frontText: widget.flashcard.front,
            backText: widget.flashcard.back,
            pronunciation: widget.flashcard.pronunciation,
            exampleText: widget.flashcard.example,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Added: ${_formatDate(widget.flashcard.createdAt)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: widget.onFavoriteToggle,
                      child: Icon(
                        widget.flashcard.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
