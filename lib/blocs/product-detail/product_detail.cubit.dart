import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'product_detail.cubit.g.dart';

part 'product_detail.state.dart';

BlocProvider createProductDetailCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<ProductDetailCubit>(
    create: (BuildContext context) => ProductDetailCubit(),
    lazy: lazy,
  );
}

ProductDetailCubit getProductDetailCubit(BuildContext context) {
  return BlocProvider.of<ProductDetailCubit>(context, listen: false);
}

@JsonSerializable()
class ProductDetailCubit extends HydratedCubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailState());

  closeDetail() {
    emit(state.copyWith(status: ProductDetailStatus.closed, product: null));
  }

  openDetail(ProductModel product) {
    emit(state.copyWith(status: ProductDetailStatus.openned, product: product));
  }

  @override
  ProductDetailState? fromJson(Map<String, dynamic> json) => ProductDetailState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ProductDetailState state) => state.toJson();
}
