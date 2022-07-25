import 'dart:core';
import 'package:flutter/cupertino.dart';

import 'custom_screen_util.dart';

Size getSize(BuildContext context) =>
    MediaQuery
        .of(context)
        .size;

double w(double width) {
  return CustomScreenUtil.getInstance().setWidth(width).ceilToDouble();
}

double h(double height) {
  return CustomScreenUtil.getInstance().setHeight(height).ceilToDouble();
}
