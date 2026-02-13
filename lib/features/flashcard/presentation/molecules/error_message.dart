import 'package:flutter/material.dart';

import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_text.dart';

/// ErrorMessage molecule component
///
/// Displays error message with optional retry button
class ErrorMessage extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Optional callback for retry button
  final VoidCallback? onRetry;

  /// Constructor
  const ErrorMessage({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

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
