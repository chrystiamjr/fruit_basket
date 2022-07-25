import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/category/category.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/quantity-selector/quantity_selector.cubit.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/ui/scenes/product-list/widgets/product_purchase_button.widget.dart';
import 'package:fruit_basket/ui/scenes/product-list/widgets/product_quantity_purchase.widget.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/collapsible_card.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/ui/widgets/list_item.widget.dart';
import 'package:fruit_basket/ui/widgets/rounded_picture.dart';
import 'package:fruit_basket/util/formatters.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:uuid/uuid.dart';

class ProductModalDetail extends StatelessWidget {
  final ProductModel model;

  const ProductModalDetail({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);
    var isBR = getLanguageCubit(context).state.currentLang!.name == 'pt_BR';
    var cartItems = getCartCubit(context).state.currentCart?.items ?? [];
    var categories = getCategoryCubit(context).state.categories;
    bool exists = cartItems.contains(model);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size.width,
          child: Card(
            elevation: 6,
            margin: EdgeInsets.zero,
            color: Basket.primaryLight,
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
                            isBR ? model.nameBr : model.name,
                            size: 16,
                            maxLines: 99,
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
                          onPressed: () async =>
                          await SingletonMemory
                              .getInstance()
                              .slider
                              .close(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(110)),
                    child: Hero(
                      tag: Key(model.uuid ?? const Uuid().v1()),
                      child: RoundedPicture(
                        url: model.photo,
                        size: w(90),
                        borderRadius: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: size.height - (exists ? h(240) : h(295)),
          color: Basket.textLight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CollapsibleCard(
                    collapsed: true,
                    title: 'productDetail.description'.tr(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Label(
                                  isBR ? model.descriptionBr : model.description,
                                  size: 12,
                                  maxLines: 99,
                                  align: TextAlign.justify,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, bottom: 4),
                        child: SizedBox(
                          width: size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...model.tags.map(
                                      (e) {
                                    final category = categories.firstWhere((el) => el.uuid == e);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Chip(
                                        backgroundColor: Basket.fromText(category.color),
                                        label: Label(
                                          isBR ? category.nameBr : category.name,
                                          size: 11,
                                          color: Basket.textLight,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CollapsibleCard(
                  title: 'productDetail.purchaseInfo'.tr(),
                  children: [
                    Column(
                      children: [
                        ListItem(
                          leading: Label(
                            'productDetail.available'.tr(),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                          trailing: Label(
                            model.quantity.toString(),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                        ListItem(
                          leading: Label(
                            'productDetail.size'.tr(),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                          trailing: Label(
                            model.size.toString(),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                        ListItem(
                          leading: Label(
                            'productDetail.price'.tr(),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                          trailing: _productPrice(context),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
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
        ..._bottomColumn(exists).map((e) => e),
      ],
    );
  }

  List<Widget> _bottomColumn(bool exists) {
    return exists
        ? [
      Padding(
        padding: EdgeInsets.only(top: h(10)),
        child: Center(
          child: Label(
            'productDetail.exists'.tr(),
            size: 16,
            color: Basket.accent,
            weight: FontWeight.w500,
          ),
        ),
      )
    ]
        : [
      BlocProvider(
        create: (_) =>
        QuantitySelectorCubit()
          ..setValue(1),
        child: Column(
          children: [
            ProductQuantityPurchase(maxQuantity: model.quantity),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ProductPurchaseButton(
                productUuid: model.uuid!,
                price: model.price,
              ),
            )
          ],
        ),
      ),
    ];
  }

  _productPrice(BuildContext context) {
    final inPromo = model.promoPercentage > 0;

    return !inPromo
        ? Label(
      "${currencyFormatter(context, price: model.price)} / ${model.size}",
      size: 12,
      weight: FontWeight.w500,
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Label(
          currencyFormatter(context, price: model.price),
          size: 10,
          decoration: TextDecoration.lineThrough,
          decorationColor: Basket.textPrimary,
          color: Basket.accent,
          weight: FontWeight.w500,
        ),
        const SizedBox(width: 5),
        Label(
          currencyFormatter(context, price: model.price * (1 - model.promoPercentage / 100)),
          size: 12,
          weight: FontWeight.w500,
        )
      ],
    );
  }
}
