// lib/generic_search_field.dart
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String labelText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  SearchField({
    required this.labelText,
    required this.onChanged,
    this.controller,
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void unfocus() {
    setState(() {
      _isFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
          if (!hasFocus && _controller.text.isEmpty) {
            _controller.clear();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _isFocused ? '' : widget.labelText,
            hintStyle: const TextStyle(color: Color.fromRGBO(142, 152, 163, 1)),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          cursorColor: Colors.grey,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
