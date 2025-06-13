//#TEMPLATE reuseable_switch
import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';

class QSwitch extends StatefulWidget {
  const QSwitch({
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
    this.validator,
    this.value,
    this.hint,
    this.helper,
  });
  final String label;
  final String? hint;
  final String? helper;
  final List<Map<String, dynamic>> items;
  final String? Function(List<Map<String, dynamic>> item)? validator;
  final List? value;
  final Function(List<Map<String, dynamic>> values, List ids) onChanged;

  @override
  State<QSwitch> createState() => _QSwitchState();
}

class _QSwitchState extends State<QSwitch> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    for (final item in widget.items) {
      items.add(Map.from(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: false,
      validator: (value) =>
          widget.validator == null ? null : widget.validator!(items),
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

              return InkWell(
                onTap: () {
                  items[index]['checked'] =
                      items[index]['checked'] == true ? false : true;
                  field.didChange(true);
                  setState(() {});

                  final selectedValues =
                      items.where((i) => i['checked'] == true).toList();

                  final ids = selectedValues.map((e) => e['value']).toList();
                  widget.onChanged(selectedValues, ids);
                },
                child: AbsorbPointer(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("${item["label"]}"),
                      ),
                      SizedBox(
                        width: 80.0,
                        child: Transform.scale(
                          scale: 0.7,
                          alignment: Alignment.centerRight,
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.all(0),
                            // title: const Text("${item["label"]}"),
                            value: item['checked'] ?? false,
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

//#END
