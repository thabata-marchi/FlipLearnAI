import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/flashcard.dart';
import '../atoms/app_card.dart';
import '../atoms/app_text.dart';

/// FlashcardItem molecule component
///
/// Displays a single flashcard preview in a list
class FlashcardItem extends StatelessWidget {
  /// The flashcard to display
  final Flashcard flashcard;

  /// Callback when card is tapped
  final VoidCallback onTap;

  /// Callback when favorite icon is toggled
  final VoidCallback onFavoriteToggle;

  /// Callback when card is deleted
  final VoidCallback onDelete;

  /// Constructor
  const FlashcardItem({
    Key? key,
    required this.flashcard,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(flashcard.id),
      background: Container(
        color: Colors.red[100],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.red[700]),
      ),
      onDismissed: (_) => onDelete(),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      flashcard.front,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      flashcard.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: onFavoriteToggle,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppText(
                flashcard.back,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              AppText(
                'Created: ${_formatDate(flashcard.createdAt)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
