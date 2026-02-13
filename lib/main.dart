import 'package:fliplearnai/app.dart';
import 'package:fliplearnai/core/data/seed_flashcards.dart';
import 'package:fliplearnai/core/di/injection.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(FlashcardModelAdapter());

  // Open Hive box
  final box = await Hive.openBox<FlashcardModel>('flashcards');

  // Initialize seed data on first launch
  await _initializeSeedData(box);

  // Initialize dependencies
  setupDependencies();

  runApp(const MyApp());
}

/// Initialize seed flashcards on first app launch
///
/// Checks if the app is running for the first time and populates
/// the Hive box with 40 pre-loaded Portuguese-English flashcards.
/// This allows users to explore the app without needing to create
/// flashcards or configure an API key.
Future<void> _initializeSeedData(Box<FlashcardModel> box) async {
  final prefs = await SharedPreferences.getInstance();
  const seedDataKey = 'has_seeded_data';

  // Check if seed data has already been loaded
  final hasSeededData = prefs.getBool(seedDataKey) ?? false;

  // Only seed data once, on first launch
  if (box.isEmpty && !hasSeededData) {
    // Add all seed flashcards to the box
    for (final card in SeedFlashcards.cards) {
      await box.add(card);
    }

    // Mark that seed data has been loaded
    await prefs.setBool(seedDataKey, true);
  }
}
