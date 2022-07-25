import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fruit_basket/blocs/cart-detail/cart_detail.cubit.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:screen_loader/screen_loader.dart';

class DefaultView extends StatefulWidget {
  final List<Widget> children;
  final bool withBottomBar;

  const DefaultView({
    Key? key,
    required this.children,
    this.withBottomBar = true,
  }) : super(key: key);

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> with ScreenLoader {
  @override
  loadingBgBlur() => 8.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    if (SingletonMemory
        .getInstance()
        .language
        .currentLang != null) {
      getLanguageCubit(context).changeLanguage(SingletonMemory
          .getInstance()
          .language
          .currentLang!
          .name);
    }

    return MultiBlocListener(
        listeners: [
          BlocListener<LoaderCubit, LoaderState>(listener: (context, loader) {
            switch (loader.status) {
              case LoaderStatus.loading:
                startLoading();
                break;
              default:
                stopLoading();
                break;
            }
          }),
          BlocListener<LanguageCubit, LanguageState>(
            listener: (context, language) {
              EasyLocalization.of(context)?.setLocale(language.currentLang!.locale);
            },
          ),
          BlocListener<CartDetailCubit, CartDetailState>(
            listener: (context, cart) {},
          ),
        ],
        child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          context.read<KeyboardCubit>().changeVisibility(isKeyboardVisible);

          return loadableWidget(
            child: Scaffold(
              extendBody: true,
              bottomNavigationBar: widget.withBottomBar ? _navigator() : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: widget.withBottomBar ? _middleButton() : null,
              body: Container(
                width: size.width,
                height: size.height,
                color: Basket.textLight,
                child: Stack(
                  children: widget.children,
                ),
              ),
            ),
          );
        }));
  }

  FloatingActionButton _middleButton() =>
      FloatingActionButton(
        backgroundColor: Basket.accent,
        child: const Icon(Icons.shopping_basket),
        onPressed: () async {
          await getCartDetailCubit(context).openDetail();
          await SingletonMemory
              .getInstance()
              .slider
              .open();
        },
      );

  BottomAppBar _navigator() =>
      BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowsRotate, color: Basket.primary),
              onPressed: () => getProductCubit(context).reload(),
            ),
            SizedBox(width: w(48)),
            IconButton(
              icon: Icon(Icons.settings, color: Basket.primary),
              onPressed: () {},
            ),
          ],
        ),
      );
}
