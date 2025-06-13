import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';

class QButton extends StatelessWidget {
  final String? label; // Make label optional
  final Color? color;
  final IconData? icon;
  final bool isOutlined;
  final bool isTextButton;
  final bool isDisabled;
  final bool isFullWidth;
  final bs size;
  final VoidCallback? onPressed;

  const QButton({
    Key? key,
    this.label, // Remove required
    this.color,
    this.icon,
    this.isOutlined = false,
    this.isTextButton = false,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.size = bs.md,
    this.onPressed,
  })  : assert(label != null || icon != null,
            'Either label or icon must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainColor = getBackgroundColor(
      color: color,
      isOutlined: isOutlined,
    );
    var iconOrTextColor = getForegroundColor(
      color: color,
      isOutlined: isOutlined || isTextButton,
    );

    final buttonStyle = isOutlined || isTextButton
        ? OutlinedButton.styleFrom(
            foregroundColor: iconOrTextColor,
            backgroundColor:
                isTextButton ? Colors.transparent : Theme.of(context).cardColor,
            elevation: 0.0,
            side: BorderSide(
              color: isTextButton ? Colors.transparent : mainColor,
              width: isTextButton ? 0.0 : 1.0,
            ),
            padding: label == null ? EdgeInsets.all(0.0) : getPadding(size),
          )
        : ElevatedButton.styleFrom(
            foregroundColor: iconOrTextColor,
            backgroundColor: mainColor,
            padding: label == null ? EdgeInsets.all(0.0) : getPadding(size),
          );
    Widget buttonChild;
    if (icon != null) {
      if (label != null) {
        buttonChild = ElevatedButton(
          onPressed: isDisabled ? null : (onPressed ?? () {}),
          style: buttonStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: spXs,
            children: [
              Icon(
                icon,
                color: iconOrTextColor,
              ),
              if (label != null && label!.isNotEmpty)
                Text(
                  label!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getFormFontSize(size),
                  ),
                ),
            ],
          ),
        );
      } else {
        buttonChild = ElevatedButton(
          onPressed: isDisabled ? null : (onPressed ?? () {}),
          style: buttonStyle,
          child: Center(
            // Wrap the Icon with Center widget
            child: Icon(
              icon,
              color: iconOrTextColor,
            ),
          ),
        );
      }
    } else {
      buttonChild = ElevatedButton(
        onPressed: isDisabled ? null : (onPressed ?? () {}),
        style: buttonStyle,
        child: Text(
          label!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getFormFontSize(size),
          ),
        ),
      );
    }

    return isFullWidth
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: buttonChild,
          )
        : buttonChild;
  }
}
