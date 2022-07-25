import 'package:flutter/material.dart';
import 'package:fruit_basket/util/custom_screen_util.dart';

class Basket {
  static fromText(String text) {
    if (text == 'primary') return Basket.primary;
    if (text == 'primaryLight') return Basket.primaryLight;
    if (text == 'accent') return Basket.accent;
    if (text == 'accentDarker') return Basket.accentDarker;
    if (text == 'opacity') return Basket.opacity;
    if (text == 'btnSuccess') return Basket.btnSuccess;
    if (text == 'btnWarning') return Basket.btnWarning;
    if (text == 'btnInfo') return Basket.btnInfo;
    if (text == 'btnError') return Basket.btnError;
    if (text == 'textPrimary') return Basket.textPrimary;
    if (text == 'textSecondary') return Basket.textSecondary;
    if (text == 'textLight') return Basket.textLight;
    if (text == 'divider') return Basket.divider;
  }

  static Color primary = const Color(0xFF633C93);
  static Color primaryLight = const Color(0xFFA688D0);
  static Color accent = const Color(0xFFD96930);
  static Color accentDarker = const Color(0xFFA55028);
  static Color opacity = const Color(0xAD000000);

  static Color btnSuccess = const Color(0xFF43A047);
  static Color btnWarning = const Color(0xFFEF6C00);
  static Color btnInfo = const Color(0xFF1E88E5);
  static Color btnError = const Color(0xFFE53935);

  static Color textPrimary = const Color(0xFF313638);
  static Color textSecondary = const Color(0xFF757575);
  static Color textLight = const Color(0xFFEFEFEF);
  static Color divider = const Color(0xFFBDBDBD);
}

TextStyle _baseStyle() => const TextStyle(fontFamily: 'Metropolis', fontWeight: FontWeight.normal);

TextStyle textStyle(double size) => _baseStyle().copyWith(fontSize: CustomScreenUtil().setSp(size, false));
