import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart-detail/cart_detail.cubit.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/ui/scenes/login/register_body.dart';
import 'package:fruit_basket/util/custom_screen_util.dart';

import 'login_body.dart';

class LoginPage extends StatelessWidget {
  static const LOGIN = 'login';
  static const REGISTER = 'register';

  final String? page;

  const LoginPage({
    Key? key,
    this.page = LOGIN,
  }) : super(key: key);

  static Route route({String page = LOGIN}) {
    return MaterialPageRoute<void>(
      builder: (_) => LoginPage(page: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.instance = CustomScreenUtil(width: 320, height: 568)
      ..init(context);

    return MultiBlocProvider(
      providers: [
        createCartDetailCubit(context),
        createLanguageCubit(context),
        createLoaderCubit(context),
        createLoginCubit(context),
        createKeyboardCubit(context),
      ],
      child: _navigateTo(),
    );
  }

  _navigateTo() {
    switch (page) {
      case LOGIN:
        return const LoginBody();
      case REGISTER:
        return const RegisterBody();
      default:
        return Container();
    }
  }
}
