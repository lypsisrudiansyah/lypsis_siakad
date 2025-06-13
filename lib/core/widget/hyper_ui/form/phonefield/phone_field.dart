import 'package:flutter/material.dart';

/*
Example of Usage:
QPhoneField(
  label: 'Phone Number',
  onChanged: (value) {
    print('Phone number: $value');
  }, 
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  },
)
*/

class QPhoneField extends StatefulWidget {
  const QPhoneField({
    required this.label,
    required this.onChanged,
    super.key,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helper,
    this.maxLength = 14,
    this.digitCount = 4,
    this.onSubmitted,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon = Icons.phone,
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
  final int digitCount;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<QPhoneField> createState() => _QPhoneFieldState();
}

class _QPhoneFieldState extends State<QPhoneField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController = widget.controller ?? TextEditingController();
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

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: textEditingController,
      focusNode: focusNode,
      validator: widget.validator,
      maxLength: widget.maxLength,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '', // Hide maxLength indicator
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: Icon(widget.suffixIcon),
        helperText: widget.helper,
        hintText: widget.hint,
      ),
      onChanged: (value) {
        final newValue =
            value.replaceAll(RegExp(r'[^0-9]'), '').replaceAll("-", "");
        widget.onChanged(newValue);
      },
      onFieldSubmitted: (value) {
        final newValue =
            value.replaceAll(RegExp(r'[^0-9]'), '').replaceAll("-", "");
        if (widget.onSubmitted != null) widget.onSubmitted!(newValue);
      },
    );
  }
}
