import 'dart:async';
import 'package:flutter/material.dart';

class QSearchField extends StatefulWidget {
  const QSearchField({
    required this.label,
    required this.onChanged,
    super.key,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength,
    this.onSubmitted,
    this.onDebounced,
    this.obscure = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.debounceDuration = const Duration(milliseconds: 800),
  });
  final String? id;
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool enabled;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final Function(String)? onDebounced;
  final Duration debounceDuration;

  @override
  State<QSearchField> createState() => _QSearchFieldState();
}

class _QSearchFieldState extends State<QSearchField> {
  TextEditingController textEditingController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    textEditingController.text = widget.value ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  String getValue() {
    return textEditingController.text;
  }

  void setValue(value) {
    textEditingController.text = value;
  }

  void resetValue() {
    textEditingController.text = '';
  }

  void focus() {
    focusNode.requestFocus();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: textEditingController,
      focusNode: focusNode,
      validator: widget.validator,
      maxLength: widget.maxLength,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
        helperText: widget.helper,
        hintText: widget.hint,
      ),
      onChanged: (value) {
        widget.onChanged(value);
        
        if (widget.onDebounced != null) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(widget.debounceDuration, () {
            widget.onDebounced!(value);
          });
        }
      },
      onFieldSubmitted: (value) {
        if (widget.onSubmitted != null) widget.onSubmitted!(value);
      },
    );
  }
}
