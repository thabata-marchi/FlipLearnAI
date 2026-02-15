import 'package:flutter/material.dart';

/// Text input field atom component
///
/// Provides a customizable text field with validation and error display
class AppTextField extends StatefulWidget {
  /// Field label
  final String label;

  /// Placeholder hint text
  final String? hint;

  /// Controller for text input
  final TextEditingController? controller;

  /// Validator function
  final String? Function(String?)? validator;

  /// Maximum number of lines
  final int maxLines;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Whether field is required
  final bool isRequired;

  /// Callback on text change
  final ValueChanged<String>? onChanged;

  /// Constructor
  // ignore: sort_constructors_first
  const AppTextField({
    required this.label, super.key,
    this.hint,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.isRequired = false,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validateInput() {
    final error = widget.validator?.call(_controller.text);
    setState(() {
      _errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          obscureText: widget.obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: _errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
