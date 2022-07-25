import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/util/formatters.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Input extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final String? hint;
  final Color? background;
  final TextEditingController? controller;
  final MaskTextInputFormatter? mask;
  final double? width;
  final Function()? onBlur;
  final Function(String)? onChanged;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final TextInputType type;
  final bool isReadOnly;
  final bool isPwd;

  const Input({
    Key? key,
    this.icon,
    this.label,
    this.hint,
    this.background,
    this.mask,
    this.width,
    this.controller,
    this.onChanged,
    this.onBlur,
    this.margin,
    this.padding,
    this.type = TextInputType.text,
    this.isReadOnly = false,
    this.isPwd = false,
  }) : super(key: key);

  InputDecoration _getInputdecoration() {
    if (isNullOrEmpty(icon)) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(0),
      );
    } else {
      return InputDecoration(
        icon: Icon(icon),
        labelText: label,
        hintText: hint,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double left = isNullOrEmpty(icon) ? 15 : 10;
    final double right = isNullOrEmpty(icon) ? 15 : 20;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!isNullOrEmpty(mask)) mask!.updateMask(mask: mask!.getMask());
    });

    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.fromLTRB(left, 4, right, 4),
      width: width ?? getSize(context).width,
      decoration: BoxDecoration(
        color: background ?? Basket.textLight,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Focus(
        child: TextField(
          obscureText: isPwd,
          controller: controller,
          keyboardType: type,
          readOnly: isReadOnly,
          decoration: _getInputdecoration(),
          inputFormatters: !(isNullOrEmpty(mask)) ? [mask!] : [],
          onChanged: (val) => onChanged?.call(val),
        ),
        onFocusChange: (hasFocus) => onBlur?.call(),
      ),
    );
  }
}
