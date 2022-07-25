import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/ui/scenes/product-list/widgets/product_category_list.widget.dart';
import 'package:fruit_basket/ui/scenes/product-list/widgets/product_grid_list.widget.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/body.widget.dart';
import 'package:fruit_basket/ui/widgets/default_view.widget.dart';
import 'package:fruit_basket/ui/widgets/header.widget.dart';
import 'package:fruit_basket/ui/widgets/input.widget.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/validator.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

import 'sups/product_sup.widget.dart';
import 'widgets/product_cart_counter.widget.dart';

class ProductListBody extends StatelessWidget {
  const ProductListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductModel> _products = [];
    Size size = getSize(context);

    return ProductSup(
        products: _products,
        child: BlocBuilder<KeyboardCubit, KeyboardState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (_, keyboardState) {
            return DefaultView(
              withBottomBar: keyboardState.status.isHidden,
              children: [
                Header(
                  title: 'products.title'.tr(),
                  subHeader: Input(
                    icon: Icons.search,
                    hint: 'products.searchBar'.tr(),
                    background: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                Body(
                  absolutHeight: keyboardState.status.isVisible ? h(210) - 15 : null,
                  upperChild: Validator(
                    validation: !keyboardState.status.isVisible,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: w(8), bottom: h(2)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Label(
                                  'products.categoryCards'.tr(),
                                  size: 13,
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ProductCategoryList(),
                            ),
                          ),
                          Divider(color: Basket.divider),
                          Padding(
                            padding: EdgeInsets.only(left: w(8), top: h(8), bottom: h(2)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Label(
                                  'products.productCards'.tr(),
                                  size: 13,
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  scrollableChild: const ProductGridList(),
                ),
                const ProductCartCounter(),
              ],
            );
          },
        ));
  }
}
