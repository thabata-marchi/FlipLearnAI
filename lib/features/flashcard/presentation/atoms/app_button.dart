import 'package:flutter/material.dart';

/// Basic button atom component
///
/// Provides a customizable button with loading state support
class AppButton extends StatelessWidget {

  /// Constructor
  const AppButton({
    required this.label, required this.onPressed, super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = 48,
    this.variant = AppButtonVariant.primary,
  });
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Whether button is in loading state
  final bool isLoading;

  /// Whether button is enabled
  final bool isEnabled;

  /// Button width (defaults to full width)
  final double width;

  /// Button height (defaults to 48)
  final double height;

  /// Button style variant
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: _buildButtonContent(),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: _buildButtonContent(),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    return isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);
  }
}

/// Button style variants
enum AppButtonVariant {
  /// Primary elevated button style
  primary,

  /// Secondary outlined button style
  secondary,

  /// Text-only button style
  text,
}
