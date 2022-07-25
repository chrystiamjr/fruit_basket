import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/category/category.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/product-detail/product_detail.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/util/helper_functions.dart';
import 'package:fruit_basket/util/screen_functions.dart';
import 'package:fruit_basket/util/singleton_memory.dart';

import 'product_grid_item.widget.dart';

class ProductGridList extends StatelessWidget {
  const ProductGridList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loader = context.read<LoaderCubit>();
    var memory = SingletonMemory.getInstance();
    Size size = getSize(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (_, state) {
            if (state.status.isInitial) {
              loader.setLoading(true);
              Future.delayed(const Duration(milliseconds: 50), () async {
                await context.read<CartCubit>().getCartData();
                await context.read<CategoryCubit>().getCategories();
                await context.read<ProductCubit>().getProducts();
              });
            }
            if (state.status.isSuccess) loader.setLoading(false);
            if (state.status.isError) {
              loader.displayMessage(context, state.errorMessage, Helper.errorBtn);
            }

            memory.productList = state.products;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 15,
              ),
              itemCount: state.products.length,
              itemBuilder: (_, i) =>
                  ProductGridItem(
                      product: state.products[i],
                      size: size,
                      onTap: () async {
                        await getProductDetailCubit(context).openDetail(state.products[i]);
                        await memory.slider.open();
                      }),
            );
          }),
    );
  }
}
