import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';
import 'package:reusekit/core/widget/button/button.dart';

class QActionButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Function? onPressed;
  final bool isDisabled;
  const QActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spMd),
      child: QButton(
        label: label,
        color: color,
        isDisabled: isDisabled,
        onPressed: () => onPressed?.call(),
      ),
    );
  }
}
