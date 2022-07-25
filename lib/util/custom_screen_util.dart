import 'package:flutter/material.dart';

class CustomScreenUtil {
  static CustomScreenUtil instance = CustomScreenUtil();

  double width;
  double height;

  bool allowFontScaling;

  static MediaQueryData? _mediaQueryData;
  static double? _screenWidth;
  static double? _screenHeight;
  static double? _pixelRatio;
  static double? _statusBarHeight;

  static double? _bottomBarHeight;

  static double? _textScaleFactor;
  static late double _textScaleFactorLimit;
  static const double _maxTextScale = 1.36;

  CustomScreenUtil({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
  });

  static CustomScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData!.padding.bottom;
    _textScaleFactorLimit = _textScaleFactor = mediaQuery.textScaleFactor;
    if (_textScaleFactor! > _maxTextScale) _textScaleFactorLimit = _maxTextScale;
  }

  static MediaQueryData? get mediaQueryData => _mediaQueryData;

  static double? get textScaleFactory => _textScaleFactor;

  static double? get pixelRatio => _pixelRatio;

  static double? get screenWidthDp => _screenWidth;

  static double? get screenHeightDp => _screenHeight;

  static double get screenWidth => _screenWidth! * _pixelRatio!;

  static double get screenHeight => _screenHeight! * _pixelRatio!;

  static double? get statusBarHeight => _statusBarHeight;

  static double? get bottomBarHeight => _bottomBarHeight;

  get scaleWidth => _screenWidth! / instance.width;

  get scaleHeight => _screenHeight! / instance.height;

  setWidth(num width) => width * scaleWidth;

  setHeight(num height) => height * scaleHeight;

  setSp(num fontSize, bool isHorizontal) =>
      allowFontScaling
          ? (isHorizontal ? setHeight(fontSize) : setWidth(fontSize)) / (_textScaleFactor ?? 1 / _textScaleFactorLimit)
          : (isHorizontal ? setHeight(fontSize) : setWidth(fontSize)) / _textScaleFactor;
}
