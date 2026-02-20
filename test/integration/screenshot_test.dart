import 'package:fliplearnai/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fliplearnai/features/flashcard/presentation/molecules/search_bar.dart' as custom_search;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Generate Screenshots', (WidgetTester tester) async {
    // 1. Iniciar o app
    app.main();
    await tester.pumpAndSettle();

    // 01_home_list.png
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01_home_list');

    // 02_search.png
    // Encontrar e tocar na barra de busca
    final searchFinder = find.byType(custom_search.SearchBar);
    if (searchFinder.evaluate().isNotEmpty) {
      await tester.tap(searchFinder);
      await tester.enterText(searchFinder, 'learn');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await binding.takeScreenshot('02_search');
      
      // Limpar busca
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    }

    // 03_create_manual.png
    // Tocar no FAB (+)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    
    // Garantir que está na aba Manual
    await tester.tap(find.text('Manual'));
    await tester.pumpAndSettle();
    
    // Preencher formulário
    await tester.enterText(find.widgetWithText(TextFormField, 'Front (English)'), 'Success');
    await tester.enterText(find.widgetWithText(TextFormField, 'Back (Portuguese)'), 'Sucesso');
    await tester.pumpAndSettle();
    await binding.takeScreenshot('03_create_manual');

    // 04_create_ai.png
    // Mudar para aba AI
    await tester.tap(find.text('AI Generation'));
    await tester.pumpAndSettle();
    
    // Preencher palavra
    await tester.enterText(find.widgetWithText(TextFormField, 'Topic or Word'), 'Technology');
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04_create_ai');

    // Voltar para Home
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 05_flip_front.png
    // Tocar no primeiro card (se existir)
    final cardFinder = find.byType(Card).first;
    if (cardFinder.evaluate().isNotEmpty) {
      await tester.tap(cardFinder);
      await tester.pumpAndSettle(); // Aguardar navegação
      await Future.delayed(const Duration(seconds: 1)); // Estabilizar
      await binding.takeScreenshot('05_flip_front');

      // 06_flip_back.png
      // Tocar no meio da tela para virar o card
      await tester.tap(find.byType(Card)); // O FlipCard usa um GestureDetector que envolve o Card
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 600)); // Aguardar animação (400ms + folga)
      await binding.takeScreenshot('06_flip_back');

      // Voltar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    }
  });
}
