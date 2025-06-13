//#TEMPLATE reuseable_radio_field
import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';

class QRadioField extends StatefulWidget {
  const QRadioField({
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
    this.validator,
    this.hint,
    this.helper,
    this.value,
  });
  final String label;
  final String? hint;
  final String? helper;
  final List<Map<String, dynamic>> items;
  final String? Function(List<Map<String, dynamic>> item)? validator;
  final Function(dynamic value, String? label) onChanged;
  final String? value;

  @override
  State<QRadioField> createState() => _QRadioFieldState();
}

class _QRadioFieldState extends State<QRadioField> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    for (final item in widget.items) {
      items.add(Map.from(item));
      if (items.last['value'] == widget.value) {
        items.last['checked'] = true;
      }
    }
  }

  void setAllItemsToFalse() {
    for (final item in items) {
      item['checked'] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: false,
      validator: (value) => widget.validator!(items),
      builder: (FormFieldState<bool> field) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: spXl,
              horizontal: spMd,
            ),
            labelText: widget.label,
            errorText: field.errorText,
            border: InputBorder.none,
            helperText: widget.helper,
            hintText: widget.hint,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(
              height: spMd,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return RadioListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text(
                  "${item["label"]}",
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                groupValue: true,
                value: item['checked'] ?? false,
                onChanged: (val) {
                  setAllItemsToFalse();
                  final newValue = val ? false : true;
                  items[index]['checked'] = newValue;
                  field.didChange(true);
                  setState(() {});

                  final String? label = items[index]['label'];
                  final foundIndex =
                      items.indexWhere((item) => item['label'] == label);
                  final dynamic value = items[foundIndex]['value'];
                  widget.onChanged(value, label);
                },
              );
            },
          ),
        );
      },
    );
  }
}

//#END
