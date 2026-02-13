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
    _flashcardStore.clearError();
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
        // Show success message and navigate back
        if (_flashcardStore.errorMessage == null &&
            !_flashcardStore.isLoading &&
            !_flashcardStore.isGeneratingWithAI) {
          // Check if we just created/generated something by monitoring the count
          // This is a simple approach; could be enhanced with explicit state
        }

        return Scaffold(
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
          body: TabBarView(
            controller: _tabController,
            children: [
              // Manual Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ManualFlashcardForm(
                  onSubmit: _handleManualSubmit,
                  isLoading: _flashcardStore.isLoading,
                ),
              ),
              // AI Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: AIFlashcardForm(
                  onGenerate: _handleAIGenerate,
                  isConfigured: _aiConfigStore.isConfigured,
                  onConfigureApi: _handleConfigureApi,
                  isGenerating: _flashcardStore.isGeneratingWithAI,
                  errorMessage: _flashcardStore.errorMessage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
