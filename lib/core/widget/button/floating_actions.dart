import 'package:flutter/material.dart';
import 'package:reusekit/core/theme/theme_config.dart';

class FloatingActions extends StatelessWidget {
  final List<Widget> children;
  const FloatingActions({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spMd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: spSm,
        children: children,
      ),
    );
  }
}
