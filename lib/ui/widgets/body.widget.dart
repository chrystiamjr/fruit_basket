import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/widget_size.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class Body extends StatefulWidget {
  final Widget? child;
  final Widget? scrollableChild;
  final Widget? upperChild;
  final double? height;
  final double? absolutHeight;

  const Body({
    Key? key,
    this.child,
    this.scrollableChild,
    this.upperChild,
    this.height,
    this.absolutHeight,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late double upperHeight = 0;
  late Size size = getSize(context);
  late double widgetHeight = size.height - (widget.height ?? h(135));

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: widget.absolutHeight ?? widgetHeight,
        width: size.width,
        decoration: BoxDecoration(
          color: Basket.textLight,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Container(
          width: size.width,
          padding: EdgeInsets.only(top: (widget.upperChild != null ? 5 : 20), bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              WidgetSize(
                onChange: (Size changedSz) {
                  setState(() => upperHeight = changedSz.height);
                },
                child: widget.upperChild ?? Container(),
              ),
              SizedBox(
                height: (widget.absolutHeight ?? widgetHeight) - upperHeight - 60, // 60 from padding
                child: widget.scrollableChild ??
                    SingleChildScrollView(
                      child: widget.child,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
