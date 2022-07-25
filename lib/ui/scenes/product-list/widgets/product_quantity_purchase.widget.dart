import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/quantity-selector/quantity_selector.cubit.dart';
import 'package:fruit_basket/models/cart_item.model.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class ProductQuantityPurchase extends StatelessWidget {
  final double textSize;
  final int maxQuantity;
  final int currQuantity;
  final CartItemModel? cart;
  final int index;

  const ProductQuantityPurchase({
    Key? key,
    required this.maxQuantity,
    this.textSize = 12,
    this.currQuantity = 1,
    this.index = -1,
    this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quantityCubit = getQuantitySelectorCubit(context);
    var cartCubit = getCartCubit(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: h(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Label(
                'productDetail.quantity'.tr(),
                size: textSize,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            elevation: 4,
            child: BlocBuilder<QuantitySelectorCubit, int>(
                buildWhen: (prev, curr) => prev != curr,
                builder: (_, state) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final newQuantity = await quantityCubit.decrement();
                            if (index != -1 && cart != null) {
                              final newCart = cart!.copyWith(quantity: newQuantity);
                              await cartCubit.updateItem(newCart, index);
                            }
                          },
                          child: const Icon(Icons.remove),
                        ),
                        Label(
                          state.toString(),
                          weight: FontWeight.bold,
                          size: textSize + 1,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final newQuantity = await quantityCubit.increment(maxQuantity);
                            if (index != -1 && cart != null) {
                              final newCart = cart!.copyWith(quantity: newQuantity);
                              await cartCubit.updateItem(newCart, index);
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
