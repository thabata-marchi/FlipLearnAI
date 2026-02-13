import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'features/flashcard/presentation/pages/home_page.dart';
import 'features/flashcard/presentation/stores/flashcard_store.dart';

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
