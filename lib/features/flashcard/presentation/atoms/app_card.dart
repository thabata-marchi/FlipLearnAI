import 'package:flutter/material.dart';

/// Card container atom component
///
/// Provides a standardized card with elevation and padding
class AppCard extends StatelessWidget {
  /// Card content widget
  final Widget child;

  /// Padding inside the card
  final EdgeInsets padding;

  /// Card elevation
  final double elevation;

  /// Card background color
  final Color? color;

  /// Border radius of the card
  final double borderRadius;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Constructor
  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.color,
    this.borderRadius = 8,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
