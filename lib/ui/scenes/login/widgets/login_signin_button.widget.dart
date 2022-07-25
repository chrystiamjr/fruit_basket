import 'package:flutter/material.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class LoginSigninButton extends StatelessWidget {
  final Function()? onPress;
  final String label;

  const LoginSigninButton({Key? key, this.onPress, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: SizedBox(
        height: h(35),
        width: w(170),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          color: Basket.accent,
          child: Center(
            child: Label(
              label,
              weight: FontWeight.bold,
              color: Basket.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
