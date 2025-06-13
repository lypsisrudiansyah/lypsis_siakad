import 'package:flutter/material.dart';
import 'package:reusekit/core/widget/hyper_ui/form/qty_field/qty_field.dart';
import 'package:reusekit/core/widget/super_card/helper.dart';

enum SuperCardType {
  //base card
  card1,
  //title over image with black overlay
  card2,
  //title over image with gradient overlay
  card3,
  //title over image
  card4,
  //image at left
  horizontal,
}

enum QtyIncrementPosition {
  priceRight,
  bottomCenter,
  bottomLeft,
  bottomRight,
}

class SuperCard extends StatelessWidget {
  final String photo;
  final String? productName;
  final String? category;
  final String? description;
  final double? rating;
  final int? reviews;
  final int? views;
  final double? price;
  final double? discountPercentage;
  final int? quantity;
  final String? badgeLabel;
  final bool enableFavorite;
  final Color? badgeColor;
  final SuperCardType cardType;
  final double? height;
  final QtyIncrementPosition qtyIncrementPosition;
  final bool isFavorite;
  final Function(bool)? onFavoriteChanged;
  final List<Widget>? actions;
  final int imageFlex;

  const SuperCard({
    super.key,
    required this.photo,
    this.productName,
    this.category,
    this.description,
    this.rating,
    this.reviews,
    this.views,
    this.price,
    this.discountPercentage,
    this.quantity,
    this.badgeLabel,
    this.enableFavorite = false,
    this.badgeColor,
    this.cardType = SuperCardType.card1,
    this.height,
    this.qtyIncrementPosition = QtyIncrementPosition.priceRight,
    this.isFavorite = false,
    this.onFavoriteChanged,
    this.actions,
    this.imageFlex = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (cardType == SuperCardType.horizontal) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                left: 0,
                width: constraints.biggest.width * 0.4,
                bottom: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    image: DecorationImage(
                      image: NetworkImage(photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (badgeLabel != null)
                        PosBadge(
                          left: 6,
                          top: 6,
                          label: badgeLabel!,
                          color: badgeColor,
                        ),
                      if (enableFavorite)
                        PosFavorite(
                          right: 6,
                          top: 6,
                          icon: Icons.favorite,
                          isFavorite: isFavorite,
                          onChanged: (value) {
                            if (onFavoriteChanged != null) {
                              onFavoriteChanged!(value);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: constraints.biggest.width * 0.4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          if (productName != null)
                            TitleText(
                              text: productName!,
                            ),
                          if (category != null)
                            CategoryText(
                              text: category!,
                            ),
                          if (description != null)
                            DescriptionText(
                              text: description!,
                            ),
                          if (rating != null ||
                              reviews != null ||
                              views != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (rating != null)
                                  IconLabel(
                                    icon: Icons.star,
                                    label: rating.toString(),
                                  ),
                                if (reviews != null)
                                  IconLabel(
                                    icon: Icons.person,
                                    label: reviews.toString(),
                                  ),
                                if (views != null)
                                  IconLabel(
                                    icon: Icons.visibility,
                                    label: views.toString(),
                                  ),
                              ],
                            ),
                          if (price != null ||
                              discountPercentage != null ||
                              quantity != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (price != null && discountPercentage != null)
                                  PricingText(
                                    price: price!,
                                    discountPercentage: discountPercentage!,
                                  ),
                                if (quantity != null)
                                  if (qtyIncrementPosition ==
                                      QtyIncrementPosition.priceRight)
                                    QtyField(
                                      value: quantity!,
                                      onChanged: (value) {},
                                    ),
                              ],
                            ),
                          if (quantity != null &&
                              qtyIncrementPosition !=
                                  QtyIncrementPosition.priceRight)
                            Builder(builder: (context) {
                              var align = MainAxisAlignment.center;
                              if (qtyIncrementPosition ==
                                  QtyIncrementPosition.bottomRight) {
                                align = MainAxisAlignment.end;
                              } else if (qtyIncrementPosition ==
                                  QtyIncrementPosition.bottomLeft) {
                                align = MainAxisAlignment.start;
                              }
                              return Row(
                                mainAxisAlignment: align,
                                children: [
                                  QtyField(
                                    value: 1,
                                    onChanged: (value) {},
                                  ),
                                ],
                              );
                            }),
                          if (actions != null && actions!.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: actions!,
                            ),
                        ],
                      ),
                    ),
                    if (actions != null && actions!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: actions!,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: height,
        child: Column(
          children: [
            Expanded(
              flex: imageFlex,
              child: Container(
                height: imageFlex > 0 ? null : 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      photo,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    if (badgeLabel != null)
                      PosBadge(
                        left: 8,
                        top: 8,
                        label: badgeLabel!,
                        color: badgeColor,
                      ),
                    if (enableFavorite)
                      PosFavorite(
                        right: 8,
                        top: 8,
                        icon: Icons.favorite,
                        isFavorite: isFavorite,
                        onChanged: (value) {
                          if (onFavoriteChanged != null) {
                            onFavoriteChanged!(value);
                          }
                        },
                      ),
                    if (cardType == SuperCardType.card2)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (productName != null)
                                TitleText(
                                  text: productName!,
                                  color: Colors.white,
                                ),
                              if (category != null)
                                CategoryText(
                                  text: category!,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (cardType == SuperCardType.card3)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.grey[900]!.withValues(alpha: 0.9),
                                Colors.grey[900]!.withValues(alpha: 0.8),
                                Colors.grey[900]!.withValues(alpha: 0.7),
                                Colors.grey[900]!.withValues(alpha: 0.6),
                                Colors.grey[900]!.withValues(alpha: 0.5),
                                Colors.grey[900]!.withValues(alpha: 0.4),
                                Colors.grey[900]!.withValues(alpha: 0.2),
                                Colors.grey[900]!.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (productName != null)
                                TitleText(
                                  text: productName!,
                                  color: Colors.white,
                                ),
                              if (category != null)
                                CategoryText(
                                  text: category!,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  if (cardType == SuperCardType.card1) ...[
                    if (productName != null)
                      TitleText(
                        text: productName!,
                      ),
                    if (category != null)
                      CategoryText(
                        text: category!,
                      ),
                  ],
                  if (description != null)
                    DescriptionText(
                      text: description!,
                    ),
                  if (rating != null || reviews != null || views != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (rating != null)
                          IconLabel(
                            icon: Icons.star,
                            label: rating.toString(),
                          ),
                        if (reviews != null)
                          IconLabel(
                            icon: Icons.person,
                            label: reviews.toString(),
                          ),
                        if (views != null)
                          IconLabel(
                            icon: Icons.visibility,
                            label: views.toString(),
                          ),
                      ],
                    ),
                  if (price != null ||
                      discountPercentage != null ||
                      quantity != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (price != null && discountPercentage != null)
                          PricingText(
                            price: price!,
                            discountPercentage: discountPercentage!,
                          ),
                        if (quantity != null)
                          if (qtyIncrementPosition ==
                              QtyIncrementPosition.priceRight)
                            QtyField(
                              value: quantity!,
                              onChanged: (value) {},
                            ),
                      ],
                    ),
                  if (quantity != null &&
                      qtyIncrementPosition != QtyIncrementPosition.priceRight)
                    Builder(builder: (context) {
                      var align = MainAxisAlignment.center;
                      if (qtyIncrementPosition ==
                          QtyIncrementPosition.bottomRight) {
                        align = MainAxisAlignment.end;
                      } else if (qtyIncrementPosition ==
                          QtyIncrementPosition.bottomLeft) {
                        align = MainAxisAlignment.start;
                      }
                      return Row(
                        mainAxisAlignment: align,
                        children: [
                          QtyField(
                            value: 1,
                            onChanged: (value) {},
                          ),
                        ],
                      );
                    }),
                  if (actions != null && actions!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: actions!,
                    ),
                ],
              ),
            ),
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
