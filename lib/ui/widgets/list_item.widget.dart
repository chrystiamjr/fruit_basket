import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class ListItem extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final IconData? icon;
  final String? title;

  const ListItem({
    Key? key,
    this.leading,
    this.trailing,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: icon != null
              ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: FaIcon(icon),
          )
              : Container(
            width: size.width / 2,
            alignment: Alignment.centerLeft,
            child: leading ?? Container(),
          ),
          title: title == null ? Container() : Label(title!),
          trailing: title != null
              ? Container()
              : Container(
            width: size.width / 2,
            alignment: Alignment.centerRight,
            child: trailing ?? Container(),
          ),
        ),
        Divider(color: Basket.divider),
      ],
    );
  }
}
