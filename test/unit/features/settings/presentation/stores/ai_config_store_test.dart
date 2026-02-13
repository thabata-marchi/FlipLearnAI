import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fliplearnai/core/services/secure_storage_service.dart';
import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';

class MockSecureStorageService extends Mock
    implements SecureStorageService {}

void main() {
  group('AIConfigStore', () {
    late AIConfigStore store;
    late MockSecureStorageService mockStorageService;

    setUp(() {
      mockStorageService = MockSecureStorageService();
      store = AIConfigStore(storageService: mockStorageService);
    });

    group('saveApiKey', () {
      test('should_ReturnFalse_When_KeyIsEmpty', () async {
        // Act
        final result = await store.saveApiKey('');

        // Assert
        expect(result, false);
        expect(store.validationError, isNotNull);
      });

      test('should_ReturnFalse_When_ClaudeKeyWrongPrefix', () async {
        // Arrange
        const invalidKey = 'sk-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        store.selectedProvider = AIProvider.claude;

        // Act
        final result = await store.saveApiKey(invalidKey);

        // Assert
        expect(result, false);
        expect(store.validationError, contains('Claude'));
      });

      test('should_ReturnFalse_When_OpenAIKeyWrongPrefix', () async {
        // Arrange
        const invalidKey = 'sk-ant-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        store.selectedProvider = AIProvider.openai;

        // Act
        final result = await store.saveApiKey(invalidKey);

        // Assert
        expect(result, false);
        expect(store.validationError, contains('OpenAI'));
      });

      test('should_ReturnFalse_When_KeyIsTooShort', () async {
        // Arrange
        const shortKey = 'sk-ant-short';

        // Act
        final result = await store.saveApiKey(shortKey);

        // Assert
        expect(result, false);
        expect(store.validationError, isNotNull);
      });
    });

    group('setProvider', () {
      test('should_UpdateSelectedProvider_When_Called', () {
        // Act
        store.setProvider(AIProvider.openai);

        // Assert
        expect(store.selectedProvider, AIProvider.openai);
      });

      test('should_SwitchFromOpenAIToClaudeProvider', () {
        // Arrange
        store.selectedProvider = AIProvider.openai;

        // Act
        store.setProvider(AIProvider.claude);

        // Assert
        expect(store.selectedProvider, AIProvider.claude);
      });
    });

    group('toggleObscureApiKey', () {
      test('should_ToggleObscureApiKey_From_True_To_False', () {
        // Arrange
        store.obscureApiKey = true;

        // Act
        store.toggleObscureApiKey();

        // Assert
        expect(store.obscureApiKey, false);
      });

      test('should_ToggleObscureApiKey_From_False_To_True', () {
        // Arrange
        store.obscureApiKey = false;

        // Act
        store.toggleObscureApiKey();

        // Assert
        expect(store.obscureApiKey, true);
      });
    });

    group('clearError', () {
      test('should_ClearValidationError_When_SetError', () {
        // Arrange
        store.validationError = 'Some error';

        // Act
        store.clearError();

        // Assert
        expect(store.validationError, null);
      });
    });

    group('API key format validation', () {
      test('should_RejectClaudeKeyWithoutPrefix', () async {
        // Arrange
        const invalidKey = 'invalid-key-aaaaaaaaaaaaaaaaaaaaaaaaa';
        store.selectedProvider = AIProvider.claude;

        // Act
        final result = await store.saveApiKey(invalidKey);

        // Assert
        expect(result, false);
      });

      test('should_RejectOpenAIKeyWithClaudePrefix', () async {
        // Arrange
        const invalidKey = 'sk-ant-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        store.selectedProvider = AIProvider.openai;

        // Act
        final result = await store.saveApiKey(invalidKey);

        // Assert
        expect(result, false);
      });

      test('should_ShowErrorMessage_ForInvalidClaudeKey', () async {
        // Arrange
        store.selectedProvider = AIProvider.claude;
        const invalidKey = 'sk-';

        // Act
        await store.saveApiKey(invalidKey);

        // Assert
        expect(store.validationError, isNotNull);
        expect(store.validationError, contains('Claude'));
        expect(store.validationError, contains('sk-ant-'));
      });

      test('should_ShowErrorMessage_ForInvalidOpenAIKey', () async {
        // Arrange
        store.selectedProvider = AIProvider.openai;
        const invalidKey = 'invalid-key';

        // Act
        await store.saveApiKey(invalidKey);

        // Assert
        expect(store.validationError, isNotNull);
        expect(store.validationError, contains('OpenAI'));
        expect(store.validationError, contains('sk-'));
      });
    });

    group('Provider initialization', () {
      test('should_DefaultToClaudeProvider_OnInit', () {
        // Assert
        expect(store.selectedProvider, AIProvider.claude);
      });

      test('should_StartWithNoError', () {
        // Assert
        expect(store.validationError, null);
      });

      test('should_StartNotConfigured', () {
        // Assert
        expect(store.isConfigured, false);
      });
    });
  });
}
