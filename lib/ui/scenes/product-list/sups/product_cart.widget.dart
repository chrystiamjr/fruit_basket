import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/ui/scenes/product-list/widgets/product_cart_item.widget.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/list_item.widget.dart';
import 'package:fruit_basket/util/formatters.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';

class ProductCart extends StatelessWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);
    var memory = SingletonMemory.getInstance();

    return Scaffold(
      body: BlocBuilder<CartCubit, CartState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (_, cart) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size.width,
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.zero,
                  color: Basket.accent,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: h(10)),
                    width: size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: w(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: h(8), top: 15),
                                child: Label(
                                  'cart.title'.tr(),
                                  size: 16,
                                  color: Basket.textLight,
                                  align: TextAlign.justify,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Basket.textLight,
                                ),
                                onPressed: () async => await memory.slider.close(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: size.height - h(250),
                color: Basket.textLight,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...?cart.currentCart?.items.map((item) {
                          final detail = memory.productList.firstWhere((el) => el.uuid == item.productUuid);
                          final price = "${'cart.price'.tr()} ${currencyFormatter(context, price: item.price)}";
                          final total = "${'cart.total'.tr()} ${currencyFormatter(context, price: item.total)}";
                          final index = cart.currentCart?.items.indexOf(item);

                          return ProductCartItem(
                            item: item,
                            detail: detail,
                            total: total,
                            price: price,
                            index: index,
                          );
                        })
                      ],
                    )),
              ),
              Container(
                height: h(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      blurRadius: 2,
                      offset: const Offset(0, -7),
                    ),
                  ],
                ),
              ),
              ListItem(
                leading: Label(
                  'cart.quantity'.tr(),
                  size: 12,
                  weight: FontWeight.w500,
                ),
                trailing: Label(
                  cart.currentCart?.finalQuantity.toString() ?? '0',
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
              ListItem(
                leading: Label(
                  'cart.totalBasket'.tr(),
                  size: 12,
                  weight: FontWeight.w500,
                ),
                trailing: Label(
                  currencyFormatter(context, price: cart.currentCart?.finalPrice ?? 0),
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8),
              //   child: ProductPurchaseButton(
              //     productUuid: model.uuid!,
              //     price: model.price,
              //   ),
              // )
            ],
          );
        },
      ),
    );
  }
}
