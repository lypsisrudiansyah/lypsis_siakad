import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class QDialogCategoryWrapPickerField extends StatefulWidget {
  final String label;
  final String? value;
  final List<Map<String, dynamic>> items;
  final Function(dynamic value, String label) onChanged;
  final bool? iconMode;
  const QDialogCategoryWrapPickerField({
    super.key,
    required this.label,
    this.value,
    this.iconMode,
    required this.items,
    required this.onChanged,
  });

  @override
  State<QDialogCategoryWrapPickerField> createState() =>
      _QDialogCategoryWrapPickerFieldState();
}

class _QDialogCategoryWrapPickerFieldState
    extends State<QDialogCategoryWrapPickerField> {
  dynamic selectedValue;

  @override
  void initState() {
    selectedValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: UniqueKey(),
      onTap: () async {
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    QCategoryWrapPicker(
                      label: widget.label,
                      items: widget.items,
                      value: selectedValue,
                      onChanged: (index, label, value, item) {
                        widget.onChanged(value, label);
                        selectedValue = value;
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: widget.iconMode == true
            ? const Icon(
                Icons.more_horiz,
                size: 16.0,
              )
            : Row(
                children: [
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: Text(
                      selectedValue ?? widget.label,
                      style: const TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
