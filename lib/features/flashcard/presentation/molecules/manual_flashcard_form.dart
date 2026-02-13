import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_button.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Manual flashcard creation form molecule
///
/// Provides a form for users to manually create flashcards
/// with front, back, example, and pronunciation fields.
class ManualFlashcardForm extends StatefulWidget {
  /// Constructor
  const ManualFlashcardForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Callback when form is submitted
  final void Function(Flashcard) onSubmit;

  /// Whether the form is in loading state
  final bool isLoading;

  @override
  State<ManualFlashcardForm> createState() => _ManualFlashcardFormState();
}

class _ManualFlashcardFormState extends State<ManualFlashcardForm> {
  late final TextEditingController _frontController;
  late final TextEditingController _backController;
  late final TextEditingController _exampleController;
  late final TextEditingController _pronunciationController;

  String? _frontError;
  String? _backError;

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController();
    _backController = TextEditingController();
    _exampleController = TextEditingController();
    _pronunciationController = TextEditingController();
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _exampleController.dispose();
    _pronunciationController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _frontError = null;
      _backError = null;
    });

    var isValid = true;

    if (_frontController.text.trim().isEmpty) {
      setState(() {
        _frontError = 'Front side is required';
      });
      isValid = false;
    }

    if (_backController.text.trim().isEmpty) {
      setState(() {
        _backError = 'Back side is required';
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleSubmit() {
    if (!_validateForm()) {
      return;
    }

    final flashcard = Flashcard(
      id: const Uuid().v4(),
      front: _frontController.text.trim(),
      back: _backController.text.trim(),
      example: _exampleController.text.trim().isEmpty
          ? null
          : _exampleController.text.trim(),
      pronunciation: _pronunciationController.text.trim().isEmpty
          ? null
          : _pronunciationController.text.trim(),
      createdAt: DateTime.now(),
    );

    widget.onSubmit(flashcard);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        AppTextField(
          label: 'Front side',
          hint: 'Enter the word or phrase to learn',
          controller: _frontController,
          isRequired: true,
          validator: (_) => _frontError,
          onChanged: (_) {
            if (_frontError != null) {
              setState(() {
                _frontError = null;
              });
            }
          },
        ),
        AppTextField(
          label: 'Back side',
          hint: 'Enter the translation or definition',
          controller: _backController,
          maxLines: 3,
          isRequired: true,
          validator: (_) => _backError,
          onChanged: (_) {
            if (_backError != null) {
              setState(() {
                _backError = null;
              });
            }
          },
        ),
        AppTextField(
          label: 'Example (optional)',
          hint: 'Enter an example sentence',
          controller: _exampleController,
          maxLines: 2,
        ),
        AppTextField(
          label: 'Pronunciation (optional)',
          hint: 'Enter pronunciation guide',
          controller: _pronunciationController,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Create Flashcard',
          isLoading: widget.isLoading,
          isEnabled: !widget.isLoading,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
