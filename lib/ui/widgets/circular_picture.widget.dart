import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/ui/theme.dart';

class CircularPicture extends StatelessWidget {
  final String? url;
  final Icon? icon;
  final Color? color;
  final FaIcon? faIcon;
  final double? size;
  final bool withBorder;

  const CircularPicture({
    Key? key,
    this.url,
    this.icon,
    this.color,
    this.faIcon,
    this.size,
    this.withBorder = true,
  }) : super(key: key);

  final double _avatarSmall = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size ?? _avatarSmall,
        width: size ?? _avatarSmall,
        decoration: BoxDecoration(
          color: color ?? Basket.textLight,
          border: withBorder ? Border.all(color: Basket.divider, width: .35) : null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: (faIcon ?? icon) ??
              CircleAvatar(
                backgroundColor: Basket.textLight,
                backgroundImage: NetworkImage(url ?? "https://robohash.org/nihilisteeos.png?size=300x300&set=set1"),
              ),
        ));
  }
}
