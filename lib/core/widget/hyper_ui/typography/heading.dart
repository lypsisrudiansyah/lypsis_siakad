import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({
    required this.title,
    required this.titleFontSize,
    required this.trailingFontSize,
    required this.actions,
    this.subtitle,
    super.key,
    this.trailing,
    this.onPressed,
    this.alternativeStyles = false,
  });
  final String title;
  final String? subtitle;
  final String? trailing;
  final double titleFontSize;
  final double trailingFontSize;
  final Function? onPressed;
  final bool alternativeStyles;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: alternativeStyles ? primaryColor.withValues(alpha: 0.1) : null,
      ),
      padding: alternativeStyles
          ? const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            )
          : const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: titleFontSize - 4,
                      color: textColor,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (onPressed != null) onPressed!();
              },
              child: Text(
                trailing!,
                style: TextStyle(
                  fontSize: trailingFontSize,
                  color: primaryColor,
                ),
              ),
            ),
          ...actions
        ],
      ),
    );
  }
}

Widget H1({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 32,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Widget H2({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 28,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Widget H3({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 24,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Widget H4({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 20,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Widget H5({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 18,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Widget H6({
  required String title,
  String? subtitle,
  String? trailing,
  Function? onPressed,
  List<Widget> actions = const [],
}) {
  return HeadingWidget(
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    titleFontSize: 16,
    trailingFontSize: 16,
    onPressed: onPressed,
    actions: actions,
  );
}

Column get templates {
  return Column(
    children: [
      //#TEMPLATE h1
      H1(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h1_label
      H1(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h1_icon
      H1(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END

      //Buatkan untuk h2, h3, h4, h5, h6
      //#TEMPLATE h2
      H2(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h2_label
      H2(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h2_icon
      H2(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END

      //#TEMPLATE h3
      H3(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h3_label
      H3(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h3_icon
      H3(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END

      //#TEMPLATE h4
      H4(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h4_label
      H4(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h4_icon
      H4(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END

      //#TEMPLATE h5
      H5(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h5_label
      H5(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h5_icon
      H5(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END

      //#TEMPLATE h6
      H6(
        title: "Category",
      ),
      //#END
      //#TEMPLATE h6_label
      H6(
        title: "Category",
        trailing: "See all",
      ),
      //#END
      //#TEMPLATE h6_icon
      H6(
        title: "Category",
        actions: [
          const Icon(
            Icons.search,
            size: 20.0,
          ),
        ],
      ),
      //#END
    ],
  );
}
