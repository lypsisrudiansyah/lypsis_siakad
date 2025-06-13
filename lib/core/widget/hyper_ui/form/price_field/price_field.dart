import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
Example of Usage:
QPriceField(
  label: 'Price',
  onChanged: (value) {
    print('Price: $value');
  }, 
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the price';
    }
    return null;
  },
)
*/

class QPriceField extends StatefulWidget {
  const QPriceField({
    required this.label,
    required this.onChanged,
    super.key,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength = 14,
    this.onSubmitted,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon = Icons.numbers,
    this.focusNode,
    this.controller,
    this.symbol = '',
    this.digit = 0,
  });
  final String? id;
  final String label;
  final String symbol;
  final int digit;
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
  State<QPriceField> createState() => _QPriceFieldState();
}

class _QPriceFieldState extends State<QPriceField> {
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
      // get only 0-9 characters
      String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      newValue = newValue.replaceAll(".", "");
      newValue = newValue.replaceAll(",", "");
      // final formattedValue = NumberFormat.currency(symbol: '\$').format(int.parse(newValue));

      final formattedValue = NumberFormat.currency(
        symbol: widget.symbol,
        decimalDigits: widget.digit,
      ).format(int.parse(newValue));
      textEditingController.text = formattedValue;
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '', // Hide maxLength indicator
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: Icon(widget.suffixIcon),
        helperText: widget.helper,
        hintText: widget.hint,
      ),
      onChanged: (value) {
        final newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
        widget.onChanged(newValue);
        formatValue(newValue);
      },
      onFieldSubmitted: (value) {
        final newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (widget.onSubmitted != null) widget.onSubmitted!(newValue);
        formatValue(newValue);
      },
    );
  }
}
