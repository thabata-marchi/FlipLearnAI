import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_button.dart';
import 'package:fliplearnai/features/flashcard/presentation/atoms/app_text_field.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

/// Page for editing an existing flashcard
///
/// Provides a pre-filled form with the flashcard's current data
/// and allows the user to update any fields.
class EditFlashcardPage extends StatefulWidget {
  /// Constructor
  const EditFlashcardPage({
    required this.flashcard,
    super.key,
  });

  /// The flashcard to edit
  final Flashcard flashcard;

  @override
  State<EditFlashcardPage> createState() => _EditFlashcardPageState();
}

class _EditFlashcardPageState extends State<EditFlashcardPage> {
  late final FlashcardStore _flashcardStore;
  late final TextEditingController _frontController;
  late final TextEditingController _backController;
  late final TextEditingController _exampleController;
  late final TextEditingController _pronunciationController;

  String? _frontError;
  String? _backError;

  @override
  void initState() {
    super.initState();
    _flashcardStore = GetIt.instance<FlashcardStore>();

    // Pre-fill controllers with current flashcard data
    _frontController = TextEditingController(text: widget.flashcard.front);
    _backController = TextEditingController(text: widget.flashcard.back);
    _exampleController =
        TextEditingController(text: widget.flashcard.example ?? '');
    _pronunciationController =
        TextEditingController(text: widget.flashcard.pronunciation ?? '');
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _exampleController.dispose();
    _pronunciationController.dispose();
    _flashcardStore.resetCreationState();
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
        _frontError = 'English word is required';
      });
      isValid = false;
    }

    if (_backController.text.trim().isEmpty) {
      setState(() {
        _backError = 'Portuguese translation is required';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleSave() async {
    if (!_validateForm()) {
      return;
    }

    final updatedFlashcard = widget.flashcard.copyWith(
      front: _frontController.text.trim(),
      back: _backController.text.trim(),
      example: _exampleController.text.trim().isEmpty
          ? null
          : _exampleController.text.trim(),
      pronunciation: _pronunciationController.text.trim().isEmpty
          ? null
          : _pronunciationController.text.trim(),
    );

    await _flashcardStore.updateFlashcard(updatedFlashcard);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        // Navigate back on successful update
        if (_flashcardStore.wasJustCreated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _flashcardStore.resetCreationState();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Flashcard updated successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            Navigator.of(context).pop(true); // Return true to indicate update
          });
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Edit Flashcard'),
            elevation: 0,
          ),
          body: Column(
            children: [
              // Show error message if present
              if (_flashcardStore.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.red[100],
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[900]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _flashcardStore.errorMessage!,
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _flashcardStore.clearError,
                        color: Colors.red[900],
                      ),
                    ],
                  ),
                ),
              // Form content
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        AppTextField(
                          label: 'English word',
                          hint: 'Enter the English word or phrase',
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
                          label: 'Portuguese translation',
                          hint: 'Enter the Portuguese translation',
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
                          label: 'Usage example (optional)',
                          hint: 'Enter an example sentence in English',
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
                          label: 'Save Changes',
                          isLoading: _flashcardStore.isLoading,
                          isEnabled: !_flashcardStore.isLoading,
                          onPressed: _handleSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
