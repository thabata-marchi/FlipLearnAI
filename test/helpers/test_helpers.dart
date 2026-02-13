import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';

/// Helper function to pump a widget with necessary providers
Future<void> pumpApp(
  WidgetTester tester,
  Widget widget, {
  FlashcardStore? flashcardStore,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: flashcardStore != null
          ? Provider<FlashcardStore>.value(
              value: flashcardStore,
              child: widget,
            )
          : widget,
    ),
  );
}

/// Helper function to pump a widget with MobX Observer
Future<void> pumpObserverWidget(
  WidgetTester tester,
  Widget Function(BuildContext) builder,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Observer(builder: builder),
      ),
    ),
  );
}

/// Helper to find widgets easily
extension WidgetFinderExtension on WidgetTester {
  /// Find a Text widget with exact match
  Finder findText(String text) => find.text(text);

  /// Find all widgets of type T
  Finder findAllType<T>() => find.byType(T);
}

/// Extension for easier assertions
extension WidgetFinderAssertion on WidgetTester {
  /// Assert widget is displayed
  void assertWidgetIsDisplayed(Finder finder) {
    expect(finder, findsWidgets);
  }

  /// Assert widget is not displayed
  void assertWidgetNotDisplayed(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Assert text is displayed
  void assertTextIsDisplayed(String text) {
    expect(find.text(text), findsWidgets);
  }

  /// Assert text is not displayed
  void assertTextNotDisplayed(String text) {
    expect(find.text(text), findsNothing);
  }
}
