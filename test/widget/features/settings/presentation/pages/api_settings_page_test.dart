import 'package:fliplearnai/core/services/secure_storage_service.dart';
import 'package:fliplearnai/features/settings/presentation/pages/api_settings_page.dart';
import 'package:fliplearnai/features/settings/presentation/stores/ai_config_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class StubSecureStorageService implements SecureStorageService {
  @override
  Future<void> deleteApiKey() async {}

  @override
  Future<String?> getApiKey() async => null;

  @override
  Future<String?> getProvider() async => null;

  @override
  Future<bool> hasApiKey() async => false;

  @override
  Future<void> saveApiKey(String key) async {}

  @override
  Future<void> saveProvider(String provider) async {}
}

void main() {
  group('APISettingsPage Widget Tests', () {
    late AIConfigStore store;
    final getIt = GetIt.instance;

    setUp(() {
      store = AIConfigStore(
        storageService: StubSecureStorageService(),
      );

      // Register store in GetIt for this test
      if (getIt.isRegistered<AIConfigStore>()) {
        getIt.unregister<AIConfigStore>();
      }
      getIt.registerSingleton<AIConfigStore>(store);
    });

    tearDown(() {
      if (getIt.isRegistered<AIConfigStore>()) {
        getIt.unregister<AIConfigStore>();
      }
    });

    Widget createWidgetUnderTest() => const MaterialApp(
      home: APISettingsPage(),
    );

    testWidgets(
      'should_DisplayApiKeyInputField',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets(
      'should_DisplaySaveButtonWhenNotConfigured',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Salvar API Key'), findsOneWidget);
      },
    );

    testWidgets(
      'should_ToggleApiKeyVisibility_WhenVisibilityButtonTapped',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - initially obscured
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Tap visibility button
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pumpAndSettle();

        // Assert - visibility button should change
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      },
    );

    testWidgets(
      'should_ChangeProvider_WhenSegmentButtonTapped',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert - initially Claude should be selected
        expect(store.selectedProvider.name, 'claude');

        // Tap OpenAI button
        await tester.tap(find.text('OpenAI'));
        await tester.pumpAndSettle();

        // Assert - OpenAI should be selected
        expect(store.selectedProvider.name, 'openai');
      },
    );

    testWidgets(
      'should_DisableSaveButton_WhenApiKeyIsEmpty',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        final saveButton = find.byType(ElevatedButton);
        expect(
          tester.widget<ElevatedButton>(saveButton).onPressed,
          null,
        );
      },
    );

    testWidgets(
      'should_DisplayTitle_APISettings',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Configurar API'), findsOneWidget);
      },
    );

    testWidgets(
      'should_DisplayProviderLabel',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(find.text('Provedor de IA'), findsOneWidget);
      },
    );

    testWidgets(
      'should_DisplayGetApiKeyLink_ForClaude',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Assert
        expect(
          find.text('Obter API key da Anthropic'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should_ChangeGetApiKeyLink_WhenProviderChanges',
      (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Change to OpenAI
        await tester.tap(find.text('OpenAI'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Obter API key da OpenAI'),
          findsOneWidget,
        );
      },
    );
  });
}
