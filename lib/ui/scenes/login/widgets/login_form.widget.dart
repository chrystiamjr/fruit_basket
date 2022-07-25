import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fruit_basket/ui/theme.dart';

class LoginForm extends StatelessWidget {
  final Size size;
  final List<Widget> children;

  const LoginForm({
    Key? key,
    required this.size,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: RoundedDiagonalPathClipper(),
        child: Container(
          color: Basket.opacity,
          height: size.height / 1.55,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
