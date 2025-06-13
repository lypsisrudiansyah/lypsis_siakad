//#TEMPLATE reuseable_date_picker
import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class QDatePicker extends StatefulWidget {
  const QDatePicker({
    required this.label,
    required this.onChanged,
    super.key,
    this.value,
    this.validator,
    this.hint,
    this.icon = Icons.calendar_today, // Default icon
    this.helper,
    this.margin,
    this.firstDate,
    this.lastDate,
  });
  final String label;
  final DateTime? value;
  final String? hint;
  final String? helper;
  final String? Function(String?)? validator;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;
  final Function(DateTime) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<QDatePicker> createState() => _QDatePickerState();
}

class _QDatePickerState extends State<QDatePicker> {
  DateTime? selectedValue;
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    controller = TextEditingController(
      text: getInitialValue(),
    );
  }

  String getInitialValue() {
    if (widget.value != null) {
      return DateFormat('d MMM y').format(widget.value!);
    }
    return '-';
  }

  String getFormattedValue() {
    if (selectedValue != null) {
      return DateFormat('d MMM y').format(selectedValue!);
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: widget.value ?? now,
          firstDate: widget.firstDate ?? DateTime(2000),
          lastDate: widget.lastDate ?? DateTime(2100),
        );
        selectedValue = pickedDate;
        controller.text = getFormattedValue();
        setState(() {});

        if (selectedValue == null) return;
        widget.onChanged(selectedValue!);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(selectedValue.toString());
            }
            return null;
          },
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helper,
            hintText: widget.hint,
            suffixIcon: Icon(widget.icon), // Add suffix icon to InputDecoration
          ),
        ),
      ),
    );
  }
}

//#END
