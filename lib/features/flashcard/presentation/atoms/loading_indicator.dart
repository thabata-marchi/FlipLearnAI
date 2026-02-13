import 'package:flutter/material.dart';

/// Loading indicator atom component
///
/// Provides a standardized circular loading spinner
class LoadingIndicator extends StatelessWidget {
  /// Size of the loading indicator
  final double size;

  /// Color of the loading indicator
  final Color? color;

  /// Constructor
  const LoadingIndicator({
    Key? key,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
