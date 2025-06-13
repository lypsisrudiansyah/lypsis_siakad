import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class QDialogTextField extends StatefulWidget {
  final String label;
  final String value;
  final Function onChanged;
  const QDialogTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<QDialogTextField> createState() => _QDialogTextFieldState();
}

class _QDialogTextFieldState extends State<QDialogTextField> {
  String value = "";

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FocusNode focusNode = FocusNode();
        Future.delayed(const Duration(milliseconds: 300), () {
          focusNode.requestFocus();
        });
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    QTextField(
                      label: widget.label,
                      focusNode: focusNode,
                      validator: Validator.required,
                      value: widget.value,
                      onChanged: (value) {},
                      onSubmitted: (value) {
                        widget.onChanged(value);
                        value = value;
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
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.edit_document,
              size: 16.0,
            ),
            const SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Text(
                value.isEmpty ? widget.label : value,
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
