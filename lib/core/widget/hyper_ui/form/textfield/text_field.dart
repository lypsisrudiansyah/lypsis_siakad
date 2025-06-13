//#TEMPLATE reuseable_text_field
import 'package:flutter/material.dart';

class QTextField extends StatefulWidget {
  const QTextField({
    required this.label,
    required this.onChanged,
    super.key,
    this.id,
    this.value,
    this.validator,
    this.hint,
    this.helperText,
    this.maxLength,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon = Icons.text_fields, // Default icon
    this.focusNode,
    this.controller,
  });
  final String? id;
  final String label;
  final String? value;
  final String? hint;
  final String? helperText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<QTextField> createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  late TextEditingController textEditingController;
  bool visible = false;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    textEditingController = widget.controller ?? TextEditingController();
    textEditingController.text = widget.value ?? '';
    super.initState();
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

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      widget.suffixIcon,
    );

    if (widget.obscureText) {
      if (visible) {
        icon = InkWell(
          onTap: () {
            visible = false;
            setState(() {});
          },
          child: const Icon(Icons.password),
        );
      } else {
        icon = InkWell(
          onTap: () {
            visible = true;
            setState(() {});
          },
          child: const Icon(Icons.visibility),
        );
      }
    }

    return TextFormField(
      enabled: widget.enabled,
      controller: textEditingController,
      focusNode: focusNode,
      validator: widget.validator,
      maxLength: widget.maxLength,
      obscureText: visible == false && widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: icon,
        helperText: widget.helperText,
        hintText: widget.hint,
      ),
      onChanged: (value) {
        widget.onChanged(value);
      },
      onFieldSubmitted: (value) {
        if (widget.onSubmitted != null) widget.onSubmitted!(value);
      },
    );
  }
}

//#END
