import 'package:fliplearnai/features/flashcard/presentation/atoms/app_icon.dart';
import 'package:flutter/material.dart';

/// SearchBar molecule component
///
/// Provides a search input field with clear button functionality
class SearchBar extends StatefulWidget {

  /// Constructor
  const SearchBar({
    required this.onChanged, super.key,
    this.hint = 'Search flashcards...',
    this.onClear,
  });
  /// Placeholder hint text
  final String hint;

  /// Callback when text changes
  final ValueChanged<String> onChanged;

  /// Callback when clear button is pressed
  final VoidCallback? onClear;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: AppIcon(
              Icons.search,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _handleClear,
            ),
        ],
      ),
    );
  }
}
