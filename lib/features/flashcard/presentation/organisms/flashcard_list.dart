import 'package:flutter/material.dart';

import '../../domain/entities/flashcard.dart';
import '../atoms/loading_indicator.dart';
import '../molecules/empty_state.dart';
import '../molecules/flashcard_item.dart';

/// FlashcardList organism component
///
/// Displays a list of flashcards with loading and empty states
class FlashcardList extends StatelessWidget {
  /// List of flashcards to display
  final List<Flashcard> flashcards;

  /// Callback when flashcard is tapped
  final ValueChanged<String> onFlashcardTap;

  /// Callback when favorite is toggled
  final ValueChanged<String> onFavoriteToggle;

  /// Callback when flashcard is deleted
  final ValueChanged<String> onDelete;

  /// Whether data is loading
  final bool isLoading;

  /// Constructor
  const FlashcardList({
    Key? key,
    required this.flashcards,
    required this.onFlashcardTap,
    required this.onFavoriteToggle,
    required this.onDelete,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    if (flashcards.isEmpty) {
      return EmptyState(
        icon: Icons.bookmark_outline,
        title: 'No Flashcards Yet',
        description: 'Create your first flashcard to start learning!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        final flashcard = flashcards[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FlashcardItem(
            flashcard: flashcard,
            onTap: () => onFlashcardTap(flashcard.id),
            onFavoriteToggle: () => onFavoriteToggle(flashcard.id),
            onDelete: () => onDelete(flashcard.id),
          ),
        );
      },
    );
  }
}
