import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reusekit/core/theme/theme_config.dart';

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final int? minItemWidth;
  const ResponsiveGridView({
    super.key,
    this.padding,
    this.minItemWidth,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Container(
        padding: padding ?? EdgeInsets.all(spMd),
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          var wantedWidth = minItemWidth ?? 460;
          var deviceWidth = constraints.biggest.width;
          if (wantedWidth > deviceWidth) {
            wantedWidth = deviceWidth.toInt();
          }

          final crossAxisCount = (constraints.maxWidth ~/ wantedWidth).ceil();
          return StaggeredGrid.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spSm,
            mainAxisSpacing: spSm,
            children: children,
          );
        }),
      ),
    );
  }
}
