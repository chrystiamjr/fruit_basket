import 'package:flutter/material.dart';

class Validator extends StatelessWidget {
  final bool validation;
  final Widget? child;
  final double mockWidth;

  const Validator({
    Key? key,
    required this.validation,
    required this.child,
    this.mockWidth = 0.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return validation ? (child ?? SizedBox(width: mockWidth)) : SizedBox(width: mockWidth);
  }
}
