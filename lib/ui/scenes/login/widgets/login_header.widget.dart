import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class LoginHeader extends StatelessWidget {
  final double width;

  const LoginHeader({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: h(50)),
          // color: Basket.opacity,
          width: width,
          child: Label(
            'Fruit Basket',
            size: 35,
            weight: FontWeight.bold,
            color: Basket.textLight,
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
