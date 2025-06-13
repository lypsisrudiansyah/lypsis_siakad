//#TEMPLATE reuseable_number_field
import 'package:flutter/material.dart';

class QtyField extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final MainAxisAlignment mainAxisAlignment;

  const QtyField({
    super.key,
    required this.value,
    required this.onChanged,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  _QtyFieldState createState() => _QtyFieldState();
}

class _QtyFieldState extends State<QtyField> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  void _increment() {
    setState(() {
      _currentValue++;
    });
    widget.onChanged(_currentValue);
  }

  void _decrement() {
    if (_currentValue > 0) {
      setState(() {
        _currentValue--;
      });
      widget.onChanged(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _decrement,
                child: Icon(Icons.remove, size: 20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Text(
                  '$_currentValue',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: _increment,
                child: Icon(Icons.add, size: 20),
              ),
            ],
          ),
        )
      ],
    );
  }
}
