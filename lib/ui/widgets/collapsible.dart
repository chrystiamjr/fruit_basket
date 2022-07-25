import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';

import 'label.widget.dart';

class Collapsible extends StatefulWidget {
  String title;
  Color? titleColor;
  double? titleSize;
  Widget? leading;
  ValueChanged<bool>? onExpansionChanged;
  List<Widget>? children;
  Color? backgroundColor;
  Color? headerBackgroundColor;
  Color? iconColor;
  Widget? trailing;
  bool? initiallyExpanded;
  bool? displayBorders;
  BorderRadius? borderRadius;

  Collapsible({
    Key? key,
    required this.title,
    this.titleColor,
    this.titleSize,
    this.headerBackgroundColor,
    this.iconColor,
    this.leading,
    this.backgroundColor,
    this.onExpansionChanged,
    this.trailing,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
    this.displayBorders = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  _CollapsibleState createState() => _CollapsibleState();
}

const Duration _kExpand = Duration(milliseconds: 200);

class _CollapsibleState extends State<Collapsible> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late bool _isExpanded = widget.initiallyExpanded!;
  late final AnimationController _controller = AnimationController(duration: _kExpand, vsync: this);
  late final Animation<double> _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  late final Animation<double> _heightFactor = _controller.drive(_easeInTween);
  late final Animation<Color?> _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
  late final Animation<Color?> _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
  late final Animation<Color?> _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

  @override
  void initState() {
    super.initState();
    setState(() {
      if (_isExpanded) _controller.value = 1.0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _isWithBorder({
    required BuildContext context,
    required Widget child,
  }) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: widget.displayBorders!
            ? Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        )
            : null,
      ),
      child: child,
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return _isWithBorder(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: Container(
              decoration: BoxDecoration(
                color: widget.headerBackgroundColor ?? Basket.textLight,
                borderRadius: widget.borderRadius,
              ),
              child: ListTile(
                onTap: _handleTap,
                leading: widget.leading,
                title: Label(
                  widget.title,
                  size: widget.titleSize ?? 15,
                  color: widget.titleColor,
                  weight: FontWeight.bold,
                ),
                trailing: widget.trailing ??
                    RotationTransition(
                        turns: _iconTurns,
                        child: Icon(
                          Icons.expand_more,
                          size: 30,
                          color: widget.iconColor ?? Basket.textPrimary,
                        )),
              ),
            ),
          ),
          ClipRect(child: Align(heightFactor: _heightFactor.value, child: child)),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.headline1!.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: _buildChildren,
        child: closed ? null : Column(children: widget.children!));
  }
}
