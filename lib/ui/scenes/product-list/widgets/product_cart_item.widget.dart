import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/quantity-selector/quantity_selector.cubit.dart';
import 'package:fruit_basket/models/cart_item.model.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/rounded_picture.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';

import 'product_quantity_purchase.widget.dart';

class ProductCartItem extends StatelessWidget {
  final CartItemModel item;
  final ProductModel detail;
  final String price;
  final String total;
  final int? index;

  const ProductCartItem({
    Key? key,
    required this.item,
    required this.detail,
    required this.price,
    required this.total,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isBR = getLanguageCubit(context).state.currentLang!.name == 'pt_BR';
    var cartCubit = getCartCubit(context);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: h(5), horizontal: w(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RoundedPicture(
                        url: detail.photo,
                        size: 50,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Label(
                            '${isBR ? detail.nameBr : detail.name} - ${detail.size}',
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 25,
                          color: Basket.btnError,
                        ),
                        onPressed: () async {
                          await cartCubit.removeItem(index!);

                          if (cartCubit.state.currentCart == null) {
                            await SingletonMemory
                                .getInstance()
                                .slider
                                .close();
                          }
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: h(5), horizontal: w(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          price,
                          size: 12,
                          weight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Label(
                          total,
                          size: 12,
                          weight: FontWeight.w500,
                          align: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocProvider(
                  create: (_) =>
                  QuantitySelectorCubit()
                    ..setValue(item.quantity),
                  child: ProductQuantityPurchase(
                    maxQuantity: detail.quantity,
                    currQuantity: item.quantity,
                    index: index ?? -1,
                    cart: item,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
