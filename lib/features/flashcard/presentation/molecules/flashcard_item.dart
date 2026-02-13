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
      child: Stack(
        children: [
          FlipCard(
            frontText: widget.flashcard.front,
            backText: widget.flashcard.back,
            pronunciation: widget.flashcard.pronunciation,
            exampleText: widget.flashcard.example,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: widget.onFavoriteToggle,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.flashcard.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            right: 56,
            child: Text(
              'Created: ${_formatDate(widget.flashcard.createdAt)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
