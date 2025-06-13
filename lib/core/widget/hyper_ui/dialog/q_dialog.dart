import 'package:flutter/material.dart';

import '../../../theme/theme_config.dart';

class QDialog extends StatefulWidget {
  final String? title;
  final String message;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final bool closeable;
  final Color? border;
  final bool isOutlined;
  final List<Widget> actions;

  QDialog({
    super.key,
    required this.message,
    required this.color,
    this.title,
    this.textColor,
    this.icon,
    this.closeable = false,
    this.border,
    this.isOutlined = false,
    this.actions = const [],
  });

  @override
  State<QDialog> createState() => _QDialogState();
}

class _QDialogState extends State<QDialog> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    if (!visible) return Container();
    return _buildAlertContent(context);
  }

  Widget _buildAlertContent(BuildContext context) {
    var mainColor = getBackgroundColor(
      color: widget.color,
      isOutlined: widget.isOutlined,
    );
    var iconOrTextColor = getForegroundColor(
      color: widget.color,
      isOutlined: widget.isOutlined,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.isOutlined ? Theme.of(context).cardColor : mainColor,
        borderRadius: BorderRadius.circular(8.0),
        border: widget.isOutlined ? Border.all(color: mainColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  color: iconOrTextColor,
                ),
              if (widget.icon != null) SizedBox(width: 12.0), // spSm spacing
              if (widget.title != null)
                Expanded(
                  child: Text(
                    widget.title ?? '',
                    style: TextStyle(
                        color: iconOrTextColor, fontWeight: FontWeight.bold),
                  ),
                ),
              if (widget.closeable)
                GestureDetector(
                  onTap: () {
                    visible = false;
                    setState(() {});
                  },
                  child: Icon(Icons.close, color: iconOrTextColor),
                ),
            ],
          ),
          if (widget.title != null) SizedBox(height: 8.0),
          Text(
            widget.message,
            style: TextStyle(color: iconOrTextColor),
          ),
          if (widget.actions.isNotEmpty) ...[
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: spSm,
              children: [...widget.actions],
            ),
          ],
        ],
      ),
    );
  }
}
