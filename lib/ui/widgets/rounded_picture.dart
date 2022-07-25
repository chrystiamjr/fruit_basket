import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';

class RoundedPicture extends StatelessWidget {
  final String? url;
  final Widget? icon;
  final double? size;
  final double? borderRadius;
  final bool withBorder;

  const RoundedPicture({
    Key? key,
    this.url,
    this.icon,
    this.size,
    this.borderRadius,
    this.withBorder = true,
  }) : super(key: key);

  final double _avatarSmall = 50;

  @override
  Widget build(BuildContext context) {
    BorderRadius _radius = BorderRadius.circular(borderRadius ?? 15);

    return Container(
        height: size ?? _avatarSmall,
        width: size ?? _avatarSmall,
        decoration: BoxDecoration(
          color: Basket.textLight,
          border: withBorder ? Border.all(color: Basket.divider, width: .35) : null,
          borderRadius: _radius,
        ),
        child: ClipRRect(
          borderRadius: _radius,
          child: icon ??
              Image.network(
                url ?? "https://robohash.org/nihilisteeos.png?size=300x300&set=set1",
                fit: BoxFit.cover,
              ),
        ));
  }
}
