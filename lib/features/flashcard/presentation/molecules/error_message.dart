import 'package:fliplearnai/features/flashcard/presentation/atoms/app_button.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_card.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// ErrorMessage molecule component
///
/// Displays error message with optional retry button
class ErrorMessage extends StatelessWidget {

  /// Constructor
  const ErrorMessage({
    required this.message, super.key,
    this.onRetry,
  });
  /// Error message to display
  final String message;

  /// Optional callback for retry button
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.red[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red[700]),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Retry',
                onPressed: onRetry!,
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
