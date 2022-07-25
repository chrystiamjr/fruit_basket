import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';

class OpacityFruityBackground extends StatelessWidget {
  final Size size;
  final double opacity;
  final BlendMode mode;

  const OpacityFruityBackground({
    Key? key,
    required this.size,
    this.opacity = 0.4,
    this.mode = BlendMode.dstATop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Basket.primary,
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(opacity), mode),
          image: const AssetImage('assets/images/splash-bg.png'),
        ),
      ),
    );
  }
}
