import 'dart:async';
import 'package:fliplearnai/app.dart';
import 'package:fliplearnai/core/config/environment.dart';
import 'package:fliplearnai/core/data/seed_flashcards.dart';
import 'package:fliplearnai/core/di/injection.dart';
import 'package:fliplearnai/features/flashcard/data/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(Environment environment) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Hive
      await Hive.initFlutter();

      // Register Hive adapters
      Hive.registerAdapter(FlashcardModelAdapter());

      // Open Hive box
      final box = await Hive.openBox<FlashcardModel>('flashcards');

      // Initialize seed data on first launch
      await _initializeSeedData(box);

      // Initialize dependencies with environment config
      // Note: You might want to pass environment to setupDependencies in the future
      setupDependencies();

      runApp(const MyApp());
    },
    (error, stackTrace) {
      // Handle errors here (e.g., report to Crashlytics)
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
    },
  );
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
  const migrationKey = 'has_migrated_to_id_keys';

  // Check if migration to ID keys is needed
  final hasMigrated = prefs.getBool(migrationKey) ?? false;
  if (!hasMigrated && box.isNotEmpty) {
    // Migration: Convert from auto-increment keys to ID keys
    final oldCards = box.values.toList();
    await box.clear();

    for (final card in oldCards) {
      await box.put(card.id, card);
    }

    await prefs.setBool(migrationKey, true);
  }

  // Check if seed data has already been loaded
  final hasSeededData = prefs.getBool(seedDataKey) ?? false;

  // Only seed data once, on first launch
  if (box.isEmpty && !hasSeededData) {
    // Add all seed flashcards to the box using their ID as key
    for (final card in SeedFlashcards.cards) {
      await box.put(card.id, card);
    }

    // Mark that seed data has been loaded
    await prefs.setBool(seedDataKey, true);
  }
}
