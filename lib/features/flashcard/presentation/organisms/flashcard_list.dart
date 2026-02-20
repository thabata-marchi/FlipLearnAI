import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/loading_indicator.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/empty_state.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/flashcard_item.dart';
import 'package:flutter/material.dart';

/// FlashcardList organism component
///
/// Displays a list of flashcards with flip animations and actions
class FlashcardList extends StatelessWidget {
  /// Constructor
  const FlashcardList({
    required this.flashcards,
    required this.onFavoriteToggle,
    required this.onDelete,
    required this.onEdit,
    this.isLoading = false,
    super.key,
  });

  /// List of flashcards to display
  final List<Flashcard> flashcards;

  /// Callback when favorite is toggled
  final ValueChanged<String> onFavoriteToggle;

  /// Callback when flashcard is deleted
  final ValueChanged<String> onDelete;

  /// Callback when edit is tapped (receives flashcard for navigation)
  final ValueChanged<Flashcard> onEdit;

  /// Whether data is loading
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    if (flashcards.isEmpty) {
      return const EmptyState(
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
            onFavoriteToggle: () => onFavoriteToggle(flashcard.id),
            onDelete: () => onDelete(flashcard.id),
            onEdit: () => onEdit(flashcard),
          ),
        );
      },
    );
  }
}
