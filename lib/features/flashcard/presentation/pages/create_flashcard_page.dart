import 'package:fliplearnai/features/flashcard/domain/entities/flashcard.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/ai_flashcard_form.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/manual_flashcard_form.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:fliplearnai/features/settings/presentation/pages/api_settings_page.dart';
import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

/// Page for creating new flashcards
///
/// Provides two tabs for flashcard creation:
/// 1. Manual: Create flashcards with manual input
/// 2. AI: Generate flashcards using AI services (Claude or OpenAI)
class CreateFlashcardPage extends StatefulWidget {
  /// Constructor
  const CreateFlashcardPage({super.key});

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage>
    with SingleTickerProviderStateMixin {
  late final FlashcardStore _flashcardStore;
  late final AIConfigStore _aiConfigStore;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _flashcardStore = GetIt.instance<FlashcardStore>();
    _aiConfigStore = GetIt.instance<AIConfigStore>();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _flashcardStore.resetCreationState();
    super.dispose();
  }

  void _handleManualSubmit(Flashcard flashcard) {
    _flashcardStore.createFlashcard(flashcard);
  }

  void _handleAIGenerate(String word, String provider) {
    _flashcardStore.generateFlashcardWithAI(
      word: word,
      aiProvider: provider,
      apiKey: '', // Will be retrieved from secure storage by store
    );
  }

  void _handleConfigureApi() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const APISettingsPage(),
      ),
    ).then((_) {
      // Reinitialize AI config store after returning from settings
      _aiConfigStore.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        // Show success message and navigate back when flashcard is created
        if (_flashcardStore.wasJustCreated) {
          // Reset state and show success feedback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _flashcardStore.resetCreationState();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Flashcard created successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate back to home page
            Navigator.of(context).pop();
          });
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Create Flashcard'),
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Manual'),
                Tab(text: 'AI'),
              ],
            ),
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
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Manual Tab
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: ManualFlashcardForm(
                          onSubmit: _handleManualSubmit,
                          isLoading: _flashcardStore.isLoading,
                        ),
                      ),
                    ),
                    // AI Tab
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: AIFlashcardForm(
                          onGenerate: _handleAIGenerate,
                          isConfigured: _aiConfigStore.isConfigured,
                          onConfigureApi: _handleConfigureApi,
                          isGenerating: _flashcardStore.isGeneratingWithAI,
                          errorMessage: _flashcardStore.errorMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
