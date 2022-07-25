import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/quantity-selector/quantity_selector.cubit.dart';
import 'package:fruit_basket/models/cart_item.model.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';

class ProductPurchaseButton extends StatelessWidget {
  final String productUuid;
  final double price;

  ProductPurchaseButton({
    Key? key,
    required this.productUuid,
    required this.price,
  }) : super(key: key);

  final _slider = SingletonMemory
      .getInstance()
      .slider;

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);
    var cart = getCartCubit(context);
    var quantityCubit = getQuantitySelectorCubit(context);

    return BlocBuilder<QuantitySelectorCubit, int>(
      buildWhen: (p, c) => p != c,
      builder: (_, quantity) =>
          MaterialButton(
            onPressed: () async {
              await cart.addItem(CartItemModel(
                productUuid: productUuid,
                price: price,
                quantity: quantity,
                total: quantity * price,
              ));

              quantityCubit.setValue(1);
              _slider.close();
            },
            child: SizedBox(
              height: h(35),
              width: size.width,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Basket.accent,
                child: Center(
                  child: Label(
                    'productDetail.addToCart'.tr(),
                    weight: FontWeight.bold,
                    color: Basket.textLight,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
