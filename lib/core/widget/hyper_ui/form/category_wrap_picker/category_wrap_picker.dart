//#TEMPLATE reuseable_category_picker
import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class QCategoryWrapPicker extends StatefulWidget {
  const QCategoryWrapPicker({
    required this.items,
    required this.onChanged,
    super.key,
    this.itemBuilder,
    this.value,
    this.validator,
    this.label,
    this.hint,
    this.helper,
  });
  final List<Map<String, dynamic>> items;
  final String? label;
  final dynamic value;
  final String? Function(int? value)? validator;
  final String? hint;
  final String? helper;

  final Function(
    Map<String, dynamic> item,
    bool selected,
    Function action,
  )? itemBuilder;

  final Function(
    int index,
    String label,
    dynamic value,
    Map<String, dynamic> item,
  ) onChanged;

  @override
  State<QCategoryWrapPicker> createState() => _QCategoryWrapPickerState();
}

class _QCategoryWrapPickerState extends State<QCategoryWrapPicker> {
  List<Map<String, dynamic>> items = [];
  int selectedIndex = -1;

  void updateIndex(newIndex) {
    selectedIndex = newIndex;
    setState(() {});
    final item = items[selectedIndex];
    final index = selectedIndex;
    final label = item['label'];
    final value = item['value'];
    widget.onChanged(index, label, value, item);
  }

  Widget getLabel() {
    if (widget.label == null) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.label}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }

  @override
  void initState() {
    items = widget.items;
    if (widget.value != null) {
      selectedIndex = items.indexWhere((i) => i['value'] == widget.value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FormField(
        initialValue: false,
        validator: (value) =>
            widget.validator!(selectedIndex == -1 ? null : selectedIndex),
        builder: (FormFieldState<bool> field) {
          return InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              labelText: widget.label,
              errorText: field.errorText,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              fillColor: Colors.transparent,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              helperText: widget.helper,
              hintText: widget.hint,
            ),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(items.length, (index) {
                final selected = selectedIndex == index;
                final item = items[index];

                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!(item, selected, () {
                    updateIndex(index);
                  });
                }

                final count = item['count'] ?? 0;

                return SizedBox(
                  height: 32,
                  child: InkWell(
                    onTap: () => updateIndex(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? primaryColor : disabledColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Wrap(
                        children: [
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 12,
                              color: selected ? Colors.white : null,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          if (count > 0)
                            CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.red,
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

//#END
