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
    super.key,
  });

  /// The flashcard to display
  final Flashcard flashcard;

  /// Callback when favorite icon is toggled
  final VoidCallback onFavoriteToggle;

  /// Callback when card is deleted
  final VoidCallback onDelete;

  @override
  State<FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<FlashcardItem> {
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.flashcard.id),
      background: Container(
        color: Colors.red[100],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.red[700]),
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
                  'Created: ${_formatDate(widget.flashcard.createdAt)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
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
          ),
        ],
      ),
    );
  }
}
