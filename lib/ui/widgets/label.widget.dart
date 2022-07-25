import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fruit_basket/ui/theme.dart';

class Label extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final int? maxLines;

  const Label(this.text, {
    Key? key,
    this.size,
    this.weight,
    this.color,
    this.align,
    this.decoration,
    this.decorationColor,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Text(
        text,
        textAlign: align,
        softWrap: maxLines != null,
        overflow: maxLines != null ? null : TextOverflow.fade,
        maxLines: maxLines,
        style: textStyle(size ?? 15).copyWith(
          color: color ?? Basket.textPrimary,
          fontWeight: weight ?? FontWeight.normal,
          decoration: decoration,
          decorationColor: decorationColor,
          height: 1.2,
        ),
      ),
    );
  }
}
