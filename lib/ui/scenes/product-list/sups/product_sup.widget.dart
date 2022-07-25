import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart-detail/cart_detail.cubit.dart';
import 'package:fruit_basket/blocs/product-detail/product_detail.cubit.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'product_cart.widget.dart';
import 'product_modal_detail.widget.dart';

class ProductSup extends StatelessWidget {
  final Widget child;
  final List<ProductModel> products;

  const ProductSup({
    Key? key,
    required this.child,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);

    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (_, detail) {
          return BlocBuilder<CartDetailCubit, CartDetailState>(
              buildWhen: (prev, curr) => prev.status != curr.status,
              builder: (_, cart) {
                return SlidingUpPanel(
                  minHeight: 0,
                  maxHeight: size.height - 80,
                  // maxHeight: size.height - MediaQuery.of(context).padding.top,
                  controller: SingletonMemory
                      .getInstance()
                      .slider,
                  isDraggable: false,
                  backdropEnabled: true,
                  defaultPanelState: PanelState.CLOSED,
                  panel: _modal(detail, cart),
                  onPanelClosed: () async {
                    await getProductDetailCubit(context).closeDetail();
                    await getCartDetailCubit(context).closeDetail();
                  },
                  body: child,
                );
              });
        });
  }

  Widget _modal(ProductDetailState detail, CartDetailState cart) {
    if (detail.status.isClosed && cart.status.isHidden) return Container();

    if (cart.status.isShown) return const ProductCart();
    if (detail.status.isOpenned) return ProductModalDetail(model: detail.selectedProduct!);

    return Container();
  }
}
