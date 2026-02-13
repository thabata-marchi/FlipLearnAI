import 'package:fliplearnai/features/flashcard/presentation/atoms/app_button.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_text_field.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/error_message.dart';
import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';
import 'package:flutter/material.dart';

/// AI-powered flashcard generation form molecule
///
/// Provides a form for users to generate flashcards using AI services
/// (Claude or OpenAI). Handles provider selection and word input.
class AIFlashcardForm extends StatefulWidget {
  /// Constructor
  const AIFlashcardForm({
    super.key,
    required this.onGenerate,
    required this.isConfigured,
    required this.onConfigureApi,
    this.isGenerating = false,
    this.errorMessage,
  });

  /// Callback when generation is requested
  final void Function(String word, String provider) onGenerate;

  /// Whether API key is configured
  final bool isConfigured;

  /// Callback to configure API key
  final VoidCallback onConfigureApi;

  /// Whether AI generation is in progress
  final bool isGenerating;

  /// Error message from AI generation
  final String? errorMessage;

  @override
  State<AIFlashcardForm> createState() => _AIFlashcardFormState();
}

class _AIFlashcardFormState extends State<AIFlashcardForm> {
  late final TextEditingController _wordController;
  late AIProvider _selectedProvider;
  String? _wordError;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _selectedProvider = AIProvider.claude;
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _wordError = null;
    });

    if (_wordController.text.trim().isEmpty) {
      setState(() {
        _wordError = 'English word is required';
      });
      return false;
    }

    return true;
  }

  void _handleGenerate() {
    if (!_validateForm()) {
      return;
    }

    widget.onGenerate(
      _wordController.text.trim(),
      _selectedProvider.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isConfigured) {
      return Column(
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'API key is not configured. '
                    'Set it up to use AI generation.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.amber[900],
                        ),
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: 'Configure API Key',
            onPressed: widget.onConfigureApi,
            variant: AppButtonVariant.secondary,
          ),
        ],
      );
    }

    return Column(
      spacing: 12,
      children: [
        Text(
          'Select AI Provider',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SegmentedButton<AIProvider>(
          segments: const [
            ButtonSegment(
              value: AIProvider.claude,
              label: Text('Claude'),
              icon: Icon(Icons.auto_awesome),
            ),
            ButtonSegment(
              value: AIProvider.openai,
              label: Text('OpenAI'),
              icon: Icon(Icons.psychology),
            ),
          ],
          selected: {_selectedProvider},
          onSelectionChanged: (selected) {
            setState(() {
              _selectedProvider = selected.first;
            });
          },
        ),
        const SizedBox(height: 8),
        AppTextField(
          label: 'English word',
          hint: 'Enter an English word to generate flashcard',
          controller: _wordController,
          isRequired: true,
          validator: (_) => _wordError,
          onChanged: (_) {
            if (_wordError != null) {
              setState(() {
                _wordError = null;
              });
            }
          },
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'About costs',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Each flashcard costs approximately:\n'
                '• Claude Haiku: ~USD 0.003\n'
                '• GPT-3.5: ~USD 0.002\n\n'
                '100 flashcards ≈ USD 0.20-0.30',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (widget.errorMessage != null)
          ErrorMessage(
            message: widget.errorMessage!,
            onRetry: _handleGenerate,
          ),
        AppButton(
          label: 'Generate with AI',
          isLoading: widget.isGenerating,
          isEnabled: !widget.isGenerating,
          onPressed: _handleGenerate,
        ),
      ],
    );
  }
}
