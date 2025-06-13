//#TEMPLATE reuseable_category_picker
import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

enum CategoryPickerMode {
  scrollable,
  expandedMode,
  wrap,
}

class QCategoryPicker extends StatefulWidget {
  const QCategoryPicker({
    required this.items,
    required this.onChanged,
    super.key,
    this.itemBuilder,
    this.value,
    this.validator,
    this.label,
    this.hint,
    this.helper,
    this.mode = CategoryPickerMode.scrollable,
  });
  final List<Map<String, dynamic>> items;
  final String? label;
  final dynamic value;
  final String? Function(int? value)? validator;
  final String? hint;
  final String? helper;
  final CategoryPickerMode mode;

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
  State<QCategoryPicker> createState() => _QCategoryPickerState();
}

class _QCategoryPickerState extends State<QCategoryPicker> {
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
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return FormField(
        initialValue: false,
        validator: (value) =>
            widget.validator!(selectedIndex == -1 ? null : selectedIndex),
        builder: (FormFieldState<bool> field) {
          return InputDecorator(
            decoration: InputDecoration(
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
              contentPadding: const EdgeInsets.all(0.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spSm,
                children: [
                  if (widget.mode == CategoryPickerMode.scrollable)
                    Container(
                      height: 38.0,
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        // color: Theme.of(context).cardColor,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(radiusMd),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 0.0, // Tighter spacing
                          children: List<Widget>.generate(
                            items.length,
                            (int index) {
                              bool selected = selectedIndex == index;
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  elevatedButtonTheme:
                                      ElevatedButtonThemeData(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      backgroundColor: selected
                                          ? primaryColor
                                          : secondaryColor,
                                      foregroundColor: selected
                                          ? Colors.white
                                          : disabledBoldColor,
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(radiusMd),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: spXs,
                                  ),
                                  child: QButton(
                                    label: items[index]['label'],
                                    color: selected
                                        ? primaryColor
                                        : disabledColor,
                                    onPressed: () {
                                      updateIndex(index);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  else if (widget.mode == CategoryPickerMode.wrap)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        spacing: spSm, // Use spSm from themeConfig
                        runSpacing: spSm, // Use spSm from themeConfig
                        children: List<Widget>.generate(
                          items.length,
                          (int index) {
                            bool selected = selectedIndex == index;
                            return Container(
                              height: 38.0,
                              child: QButton(
                                label: items[index]['label'],
                                color:
                                    selected ? primaryColor : secondaryColor,
                                onPressed: () {
                                  updateIndex(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(radiusMd),
                        ),
                      ),
                      child: Row(
                        spacing: 0.0, // Tighter spacing
                        children: List<Widget>.generate(
                          items.length,
                          (int index) {
                            bool selected = selectedIndex == index;
                            return Expanded(
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  elevatedButtonTheme:
                                      ElevatedButtonThemeData(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      backgroundColor: selected
                                          ? primaryColor
                                          : secondaryColor,
                                      foregroundColor: selected
                                          ? Colors.white
                                          : disabledBoldColor,
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(radiusMd),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: QButton(
                                  label: items[index]['label'],
                                  color: selected
                                      ? primaryColor
                                      : secondaryColor,
                                  onPressed: () {
                                    updateIndex(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

//#END
