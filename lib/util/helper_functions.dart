import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class Helper {
  static const infoBtn = 'info';
  static const errorBtn = 'error';
  static const successBtn = 'success';

  static Map<String, dynamic> getColorFromType(String type) {
    switch (type) {
      case successBtn:
        return {'bg': Basket.btnSuccess, 'txt': Basket.textLight, 'icn': Icons.check_circle};
      case errorBtn:
        return {'bg': Basket.btnError, 'txt': Basket.textLight, 'icn': Icons.warning};
      default:
        return {'bg': Basket.textLight, 'txt': Basket.textPrimary, 'icn': Icons.info};
    }
  }
}

displaySnackbar(BuildContext context, {
  String? info = '',
  int duration = 3,
  String type = Helper.infoBtn,
}) {
  final colors = Helper.getColorFromType(type);

  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors['bg'],
        duration: Duration(seconds: duration),
        elevation: 8,
        content: SizedBox(
          height: h(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      colors['icn'],
                      color: colors['txt'],
                      size: 17,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Label(
                      info!,
                      size: 10,
                      maxLines: 4,
                      color: colors['txt'],
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}
