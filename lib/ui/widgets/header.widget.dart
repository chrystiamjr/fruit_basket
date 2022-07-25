import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/ui/scenes/login/page.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/opacity_fruity_background.widget.dart';
import 'package:fruit_basket/ui/widgets/validator.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class Header extends StatelessWidget {
  final bool withBack;
  final String title;
  final double? height;
  final Color? textColor;
  final Widget? subHeader;

  const Header({
    Key? key,
    this.withBack = false,
    this.title = '',
    this.height,
    this.textColor,
    this.subHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final login = getLoginCubit(context);
    Size size = getSize(context);

    return Stack(
      children: [
        OpacityFruityBackground(
          size: size,
          opacity: .2,
        ),
        Container(
          height: height ?? h(155),
          width: size.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Validator(
                        validation: withBack,
                        mockWidth: 15,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: textColor ?? Basket.textLight,
                          ),
                          onPressed: null,
                        ),
                      ),
                      Expanded(
                        child: Label(
                          title,
                          size: 18,
                          color: textColor ?? Basket.textLight,
                          weight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: textColor ?? Basket.accent,
                        ),
                        onPressed: () async {
                          await login.signout();
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const LoginPage(page: LoginPage.LOGIN),
                            ),
                                (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  Validator(
                    validation: subHeader != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: subHeader,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
