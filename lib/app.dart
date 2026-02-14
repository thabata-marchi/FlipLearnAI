import 'package:fliplearnai/features/flashcard/presentation/pages/home_page.dart';
import 'package:fliplearnai/features/flashcard/presentation/stores/flashcard_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

/// Root widget of the application
class MyApp extends StatelessWidget {
  /// Constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FlashcardStore>(
      create: (_) => GetIt.instance<FlashcardStore>(),
      child: MaterialApp(
        title: 'FlipLearnAI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
