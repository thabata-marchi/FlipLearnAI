import 'package:fliplearnai/features/flashcard/presentation/atoms/app_button.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_text.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/empty_state_icon.dart';
import 'package:flutter/material.dart';

/// EmptyState molecule component
///
/// Displays an empty state with icon, title, and optional action
class EmptyState extends StatelessWidget {

  /// Constructor
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.actionLabel,
    this.onAction,
  });
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Description text
  final String description;

  /// Optional action button label
  final String? actionLabel;

  /// Optional callback for action button
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyStateIcon(icon: icon),
          const SizedBox(height: 16),
          AppText(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AppText(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            AppButton(
              label: actionLabel!,
              onPressed: onAction!,
              width: 200,
            ),
          ],
        ],
      ),
    );
  }
}
