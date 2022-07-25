import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/ui/widgets/label.widget.dart';
import 'package:fruit_basket/util/screen_functions.dart';

class ProductCartCounter extends StatelessWidget {
  const ProductCartCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = getSize(context);

    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (_, cart) {
        final isEmpty = cart.status.isEmpty;

        return Positioned(
          bottom: h(30),
          left: size.width / 2 + w(17),
          child: AnimatedContainer(
            height: isEmpty ? 0 : 35,
            width: isEmpty ? 0 : 35,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Basket.accentDarker,
            ),
            child: Center(
              child: Label(
                cart.currentCart?.finalQuantity.toString() ?? '',
                size: 11,
                weight: FontWeight.w500,
                color: Basket.textLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
