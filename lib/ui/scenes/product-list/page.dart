import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart-detail/cart_detail.cubit.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/category/category.cubit.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/blocs/product-detail/product_detail.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/blocs/quantity-selector/quantity_selector.cubit.dart';
import 'package:fruit_basket/ui/scenes/product-list/body.dart';
import 'package:fruit_basket/util/custom_screen_util.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProductListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.instance = CustomScreenUtil(width: 320, height: 568)
      ..init(context);

    return MultiBlocProvider(
      providers: [
        createCategoryCubit(context),
        createCartCubit(context),
        createCartDetailCubit(context),
        createLanguageCubit(context),
        createLoginCubit(context),
        createLoaderCubit(context),
        createKeyboardCubit(context),
        createQuantitySelectorCubit(context),
        createProductCubit(context),
        createProductDetailCubit(context),
      ],
      child: const ProductListBody(),
    );
  }
}
