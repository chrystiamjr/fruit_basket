import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/circular_picture.widget.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class ProductUppercard extends StatelessWidget {
  final Size size;
  final Color color;
  final IconData icon;
  final String title;
  final double? iconSize;

  const ProductUppercard({
    Key? key,
    required this.size,
    required this.color,
    required this.icon,
    required this.title,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
        width: w(90),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircularPicture(
                  size: 35,
                  color: color,
                  withBorder: false,
                  faIcon: FaIcon(
                    icon,
                    size: iconSize ?? 35,
                    color: Basket.textLight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Label(
                title,
                size: 11,
                color: color,
                weight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
