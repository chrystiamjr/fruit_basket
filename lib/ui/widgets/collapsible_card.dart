import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';

import 'collapsible.dart';

class CollapsibleCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  final double titleSize;
  final double width;

  final Color? headerColor;
  final Color? textColor;

  final bool collapsed;

  const CollapsibleCard({
    Key? key,
    required this.title,
    required this.children,
    this.titleSize = 12,
    this.width = 500,
    this.collapsed = false,
    this.headerColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Collapsible(
          initiallyExpanded: !collapsed,
          title: title,
          titleSize: titleSize,
          titleColor: textColor ?? Basket.textLight,
          iconColor: textColor ?? Basket.textLight,
          headerBackgroundColor: headerColor ?? Basket.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          children: children,
        ),
      ),
    );
  }
}
