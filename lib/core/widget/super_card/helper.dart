import 'package:flutter/material.dart';

class PosFavorite extends StatefulWidget {
  final double? left;
  final double? top;
  final double? bottom;
  final double? right;
  final IconData icon;
  final bool isFavorite;
  final ValueChanged<bool> onChanged;

  const PosFavorite({
    super.key,
    this.left,
    this.top,
    this.bottom,
    this.right,
    required this.icon,
    required this.isFavorite,
    required this.onChanged,
  });

  @override
  _PosFavoriteState createState() => _PosFavoriteState();
}

class _PosFavoriteState extends State<PosFavorite> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onChanged(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      bottom: widget.bottom,
      right: widget.right,
      child: InkWell(
        onTap: _toggleFavorite,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
            border: Border.all(
              width: 0.2,
              color: Colors.grey[200]!,
            ),
          ),
          // child: IconButton(
          //   padding: EdgeInsets.all(0.0),
          //   icon: Icon(
          //     widget.icon,
          //     size: 12.0,
          //   ),
          //   color: _isFavorite ? Colors.red : Colors.grey,
          //   onPressed: _toggleFavorite,
          // ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.icon,
              size: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}

class PosBadge extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final String label;
  final Color? color;

  const PosBadge({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '$label',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }
}

class PricingText extends StatelessWidget {
  final double price;
  final double discountPercentage;

  const PricingText({
    super.key,
    required this.price,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice = price - (price * (discountPercentage / 100));

    return Row(
      children: [
        Text(
          '\$${discountedPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${discountPercentage.toStringAsFixed(0)}% off',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 8.0,
              ),
            ),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryText extends StatelessWidget {
  final String text;
  final Color? color;
  const CategoryText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 12.0,
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  const TitleText({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const IconLabel({
    Key? key,
    required this.icon,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16.0,
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}

class DescriptionText extends StatelessWidget {
  final String text;

  const DescriptionText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
