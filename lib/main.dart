import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  // Initialize dependencies
  setupDependencies();

  runApp(const MyApp());
}
