import 'package:flutter/material.dart';

/// Icon atom component
///
/// Provides consistent icon sizing and coloring
class AppIcon extends StatelessWidget {
  /// The icon data
  final IconData icon;

  /// Size of the icon
  final double size;

  /// Color of the icon
  final Color? color;

  /// Constructor
  // ignore: sort_constructors_first
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
