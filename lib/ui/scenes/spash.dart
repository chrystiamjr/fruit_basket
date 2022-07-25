import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/ui/scenes/login/page.dart';
import 'package:fruit_basket/ui/scenes/product-list/page.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/custom_screen_util.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';

import '../widgets/opacity_fruity_background.widget.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var memory = SingletonMemory.getInstance();
    CustomScreenUtil.instance = CustomScreenUtil(width: 320, height: 568)
      ..init(context);
    context.read<LanguageCubit>().getLanguageByLocation();

    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        String? pwd = memory.storage.read('pwd');
        if ((state.status.isAccepted || state.status.isRejected) && state.currentLang != null) {
          if (pwd == null || pwd.isEmpty || memory.user == null) {
            Future.delayed(
              const Duration(seconds: 2),
                  () async => await Navigator.pushReplacement(context, LoginPage.route(page: LoginPage.LOGIN)),
            );
          } else {
            final login = getLoginCubit(context);
            Future.delayed(const Duration(milliseconds: 50), () async {
              await login.asyncEmit(LoginState(emailText: memory.user!.email!, passwordText: pwd));
              await login.signin();

              if (login.state.status.isError) {
                await Navigator.pushReplacement(context, LoginPage.route(page: LoginPage.LOGIN));
                return;
              }

              await Navigator.pushReplacement(context, ProductListPage.route());
            });
          }
        }
        return _content(context);
      },
    );
  }

  Widget _content(BuildContext context) {
    Size size = getSize(context);

    return Stack(children: [
      OpacityFruityBackground(size: size),
      Align(
        alignment: Alignment.center,
        child: ClipPath(
          clipper: RoundedDiagonalPathClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(50),
            ),
            width: size.width - 30,
            height: 250,
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Label(
              'Fruit Basket',
              size: 30,
              color: Basket.textLight,
              align: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FaIcon(
              FontAwesomeIcons.basketShopping,
              color: Basket.textLight,
              size: 50,
            )
          ],
        ),
      )
    ]);
  }
}
