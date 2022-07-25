import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:fruit_basket/models/product_filter.model.dart';
import 'package:fruit_basket/repositories/products.reporitory.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:fruit_basket/util/validators.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'product.cubit.g.dart';

part 'product.state.dart';

BlocProvider createProductCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<ProductCubit>(
    create: (BuildContext context) => ProductCubit(),
    lazy: lazy,
  );
}

ProductCubit getProductCubit(BuildContext context) {
  return BlocProvider.of<ProductCubit>(context, listen: false);
}

@JsonSerializable()
class ProductCubit extends HydratedCubit<ProductState> {
  final _memory = SingletonMemory.getInstance();

  ProductCubit() : super(ProductState());

  reload() {
    _emitPositiveState(status: ProductStatus.initial);
  }

  Future getProducts() async {
    _emitPositiveState(status: ProductStatus.loading);

    try {
      _emitPositiveState(
        status: ProductStatus.success,
        products: await _fetch(),
      );
    } on FirebaseException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitError(err.toString());
    }
  }

  Future filter(ProductFilter filter) async {
    _emitPositiveState(status: ProductStatus.loading);

    try {
      final models = await _fetch();

      final filtered = [] as List<ProductModel>;
      switch (filter.type) {
        case FilterType.like:
        case FilterType.exists:
          final items = models.where((prod) => (prod.toJson())[filter.field].toString().contains(filter.value));
          filtered.addAll(items);
          break;
        default:
          filtered.addAll(models);
          break;
      }

      _emitPositiveState(
        status: ProductStatus.success,
        products: filtered,
      );
    } on FirebaseException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitError(err.toString());
    }
  }

  Future<List<ProductModel>> _fetch() async {
    final snapshots = await ProductsRepository.getAll();
    final models = snapshots.map((e) => e.data()).toList();
    return models;
  }

  _emitPositiveState({
    ProductStatus? status,
    List<ProductModel>? products,
  }) {
    emit(state.copyWith(
      status: status,
      products: products ?? [],
      error: null,
    ));

    _memory.products = state;
  }

  _emitError(String error) {
    emit(state.copyWith(
      status: ProductStatus.error,
      products: null,
      error: validateCodeErrors(error),
    ));

    _memory.products = state;
  }

  @override
  ProductState? fromJson(Map<String, dynamic> json) => ProductState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ProductState state) => state.toJson();
}
