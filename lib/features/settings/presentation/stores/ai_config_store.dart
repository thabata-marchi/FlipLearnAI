import 'package:fliplearnai/core/services/secure_storage_service.dart';
import 'package:mobx/mobx.dart';

part 'ai_config_store.g.dart';

/// AI provider types
enum AIProvider {
  /// Anthropic Claude
  claude,

  /// OpenAI GPT
  openai,
}

/// MobX store for AI configuration
///
/// Manages AI API key configuration and provider selection.
/// Keys are stored securely using platform-specific encryption.
class AIConfigStore = _AIConfigStoreBase with _$AIConfigStore;

abstract class _AIConfigStoreBase with Store {

  /// Constructor
  _AIConfigStoreBase({
    required SecureStorageService storageService,
  }) : _storageService = storageService;
  /// Secure storage service for API keys
  final SecureStorageService _storageService;

  /// Whether API key is configured
  @observable
  bool isConfigured = false;

  /// Currently selected AI provider
  @observable
  AIProvider selectedProvider = AIProvider.claude;

  /// API key validation error message
  @observable
  String? validationError;

  /// Whether API key is obscured in text field
  @observable
  bool obscureApiKey = true;

  /// Whether API key is currently being validated
  @observable
  bool isValidating = false;

  /// Initialize store from persistent storage
  ///
  /// This should be called once during app initialization
  @action
  Future<void> initialize() async {
    isConfigured = await _storageService.hasApiKey();
    final providerString = await _storageService.getProvider();

    if (providerString != null) {
      try {
        selectedProvider = AIProvider.values.firstWhere(
          (p) => p.name == providerString,
          orElse: () => AIProvider.claude,
        );
      } catch (_) {
        selectedProvider = AIProvider.claude;
      }
    }
  }

  /// Save API key to secure storage
  ///
  /// Validates format before saving (no API calls for cost savings).
  /// Returns true if save was successful, false otherwise.
  @action
  Future<bool> saveApiKey(String apiKey) async {
    validationError = null;

    // Validate format only (no API calls)
    if (!_isValidKeyFormat(apiKey)) {
      validationError = _getFormatErrorMessage();
      return false;
    }

    // Save to secure storage
    try {
      await _storageService.saveApiKey(apiKey);
      await _storageService.saveProvider(selectedProvider.name);
      isConfigured = true;
      return true;
    } catch (e) {
      validationError = 'Erro ao salvar API key: $e';
      return false;
    }
  }

  /// Remove API key from secure storage
  @action
  Future<void> removeApiKey() async {
    try {
      await _storageService.deleteApiKey();
      isConfigured = false;
      validationError = null;
    } catch (e) {
      validationError = 'Erro ao remover API key: $e';
    }
  }

  /// Set selected AI provider
  ///
  /// Updates the provider selection without changing the API key.
  @action
  void setProvider(AIProvider newProvider) {
    selectedProvider = newProvider;
  }

  /// Toggle API key visibility
  @action
  void toggleObscureApiKey() {
    obscureApiKey = !obscureApiKey;
  }

  /// Clear validation error
  @action
  void clearError() {
    validationError = null;
  }

  /// Validate API key format based on selected provider
  ///
  /// This only validates the format, NOT the validity of the key.
  /// Actual validation happens when the key is used to call the API.
  ///
  /// Claude keys must start with "sk-ant-" and be reasonably long.
  /// OpenAI keys must start with "sk-" and be reasonably long.
  bool _isValidKeyFormat(String key) {
    if (key.isEmpty) return false;
    if (key.trim().length < 20) return false;

    switch (selectedProvider) {
      case AIProvider.claude:
        return key.startsWith('sk-ant-');
      case AIProvider.openai:
        final notClaude = !key.startsWith('sk-ant-');
        return key.startsWith('sk-') && notClaude;
    }
  }

  /// Get user-friendly validation error message
  String _getFormatErrorMessage() {
    switch (selectedProvider) {
      case AIProvider.claude:
        return 'Chave Claude deve começar com "sk-ant-" '
            'e ter no mínimo 20 caracteres';
      case AIProvider.openai:
        return 'Chave OpenAI deve começar com "sk-" '
            'e ter no mínimo 20 caracteres';
    }
  }
}
