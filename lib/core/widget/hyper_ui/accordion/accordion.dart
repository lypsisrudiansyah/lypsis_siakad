import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class AccordionSection extends StatelessWidget {
  final String title;
  final List<AccordionItem> children;

  const AccordionSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fsLg,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: spSm),
        ...children,
      ],
    );
  }
}

class AccordionItem extends StatefulWidget {
  final String title;
  final Widget content;
  final IconData? icon;

  const AccordionItem({super.key, 
    required this.title,
    required this.content,
    this.icon,
  });

  @override
  _AccordionItemState createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                if (widget.icon != null) Icon(widget.icon, size: 20),
                if (widget.icon != null) SizedBox(width: spXs),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: textColor,
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(spMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [widget.content],
              ),
            ),
        ],
      ),
    );
  }
}
