import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/ui/scenes/product-list/page.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/default_view.widget.dart';
import 'package:fruit_basket/ui/widgets/input.widget.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/opacity_fruity_background.widget.dart';
import 'package:fruit_basket/util/helper_functions.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'page.dart';
import 'widgets/login_form.widget.dart';
import 'widgets/login_header.widget.dart';
import 'widgets/login_signin_button.widget.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    var loader = context.read<LoaderCubit>();
    Size size = getSize(context);

    return DefaultView(
      withBottomBar: false,
      children: [
        OpacityFruityBackground(
          size: size,
          mode: BlendMode.dstIn,
        ),
        BlocBuilder<KeyboardCubit, KeyboardState>(
          builder: (context, state) =>
          state.status == KeyboardStatus.hidden ? LoginHeader(width: size.width) : Container(),
        ),
        LoginForm(
          size: size,
          children: [
            SizedBox(height: h(60)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacement(
                          context,
                          LoginPage.route(page: LoginPage.LOGIN),
                        ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Label(
                        'login.signin'.tr(),
                        size: 13,
                        decoration: TextDecoration.underline,
                        weight: FontWeight.bold,
                        color: Basket.textLight,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Label(
                    'login.signup'.tr(),
                    size: 30,
                    color: Basket.textLight,
                    align: TextAlign.end,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: h(35)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Input(
                icon: Icons.mail,
                hint: 'login.mail'.tr(),
                type: TextInputType.emailAddress,
                onChanged: (val) => loginCubit.onchangeField(field: LoginFields.email, val: val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Input(
                isPwd: true,
                icon: Icons.lock,
                hint: 'login.pwd'.tr(),
                onChanged: (val) => loginCubit.onchangeField(field: LoginFields.password, val: val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Input(
                isPwd: true,
                icon: Icons.lock,
                hint: 'login.confirmPwd'.tr(),
                onChanged: (val) => loginCubit.onchangeField(field: LoginFields.confirmation, val: val),
              ),
            ),
            SizedBox(height: h(18)),
            LoginSigninButton(
              label: 'login.finishBtn'.tr(),
              onPress: () async {
                loader.setLoading(true);

                await loginCubit.signup();
                if (loginCubit.state.status.isError) {
                  loader.displayMessage(context, loginCubit.state.errorMessage, Helper.errorBtn);
                  return;
                }

                await SingletonMemory
                    .getInstance()
                    .storage
                    .write('pwd', loginCubit.state.passwordText);
                await loader.displayMessage(context, 'User created and signed-in successfully', Helper.successBtn);
                await Future.delayed(
                  const Duration(seconds: 2),
                      () => Navigator.pushReplacement(context, ProductListPage.route()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
