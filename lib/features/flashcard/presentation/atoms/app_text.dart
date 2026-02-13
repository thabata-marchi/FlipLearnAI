import 'package:flutter/material.dart';

/// Text atom component
///
/// Provides standardized text rendering with consistent styling
class AppText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Optional text style
  final TextStyle? style;

  /// Text alignment
  final TextAlign textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow overflow;

  /// Constructor
  const AppText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
