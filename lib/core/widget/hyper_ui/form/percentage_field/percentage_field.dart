import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
Example of Usage:
QPercentageField(
  label: 'Percentage',
  onChanged: (value) {
    print('Percentage: $value');
  }, 
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the percentage';
    }
    return null;
  },
)
*/

class QPercentageField extends StatefulWidget {
  const QPercentageField({
    required this.label,
    required this.onChanged,
    super.key,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength = 6,
    this.onSubmitted,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon = Icons.percent,
    this.focusNode,
    this.controller,
  });
  final String? id;
  final String label;
  final String? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<QPercentageField> createState() => _QPercentageFieldState();
}

class _QPercentageFieldState extends State<QPercentageField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController = widget.controller ?? TextEditingController();
    formatValue(widget.value ?? '');
    super.initState();
  }

  String getValue() {
    return textEditingController.text;
  }

  void resetValue() {
    textEditingController.text = '';
  }

  void focus() {
    focusNode.requestFocus();
  }

  void formatValue(value) {
    try {
      final newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
      textEditingController.text = '$newValue';
    } on Exception {
      textEditingController.text = "";
    }
  }

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: textEditingController,
      focusNode: focusNode,
      validator: widget.validator,
      maxLength: widget.maxLength,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '', // Hide maxLength indicator
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: Icon(widget.suffixIcon),
        helperText: widget.helper,
        hintText: widget.hint,
      ),
      onChanged: (value) {
        final newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
        widget.onChanged(newValue);
        formatValue(newValue);
      },
      onFieldSubmitted: (value) {
        final newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
        if (widget.onSubmitted != null) widget.onSubmitted!(newValue);
        formatValue(newValue);
      },
    );
  }
}
