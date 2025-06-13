//#TEMPLATE reuseable_card
// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class QCard extends StatelessWidget {
  const QCard({
    required this.children,
    super.key,
    this.title,
    this.subtitle,
    this.padding,
    this.spacing,
    this.actions = const [],
    this.footers = const [],
    this.flex = 0,
    this.headerColor,
    this.color,
  });
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;
  final List<Widget> actions;
  final List<Widget> footers;
  final int flex;
  final double? spacing;
  final Color? headerColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var child = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(
          width: 0.2,
          color: Color(0x19000000),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 24,
            offset: Offset(0, 11),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: spSm,
                vertical: spXs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            '$subtitle',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (actions.isNotEmpty)
                    Container(
                      height: 32,
                      child: Row(
                        children: actions,
                      ),
                    ),
                ],
              ),
            ),
          ],
          //Footers Codes
          Expanded(
            flex: flex,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: padding ?? EdgeInsets.all(spMd),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing ?? spSm,
                children: [
                  if (children.isNotEmpty) ...children,
                  if (footers.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: footers,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
    if (flex == 0) return child;
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}
//#END
