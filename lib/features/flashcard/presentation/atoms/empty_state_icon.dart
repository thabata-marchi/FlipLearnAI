import 'package:flutter/material.dart';

/// Empty state icon atom component
///
/// Provides a large icon for empty state displays
class EmptyStateIcon extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// Size of the icon
  final double size;

  /// Color of the icon
  final Color? color;

  /// Constructor
  // ignore: sort_constructors_first
  const EmptyStateIcon({
    required this.icon, super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color ?? Colors.grey[400],
    );
  }
}
