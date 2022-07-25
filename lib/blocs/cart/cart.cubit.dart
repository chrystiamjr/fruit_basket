import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/models/cart.model.dart';
import 'package:fruit_basket/models/cart_item.model.dart';
import 'package:fruit_basket/repositories/cart.repository.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'cart.cubit.g.dart';

part 'cart.state.dart';

BlocProvider createCartCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<CartCubit>(
    create: (BuildContext context) => CartCubit(),
    lazy: lazy,
  );
}

CartCubit getCartCubit(BuildContext context) {
  return BlocProvider.of<CartCubit>(context, listen: false);
}

@JsonSerializable()
class CartCubit extends HydratedCubit<CartState> {
  final _memory = SingletonMemory.getInstance();

  CartCubit() : super(CartState());

  Future getCartData() async {
    emit(state.copyWith(status: CartStatus.loading));

    final data = await CartRepository.get(_memory.user!.uid);
    print(data?.data());

    emit(state.copyWith(status: data == null ? CartStatus.empty : CartStatus.success, cart: data?.data()));
    _memory.cart = state;
  }

  Future addItem(CartItemModel item) async {
    emit(state.copyWith(status: CartStatus.loading));

    if (state.currentCart?.uuid != null) {
      return await updateItem(item, -1);
    }

    CartModel cart = (state.currentCart ?? CartModel(userUuid: _memory.user!.uid)).addItem(item);
    final newCart = await _recalculate(cart, emitStatus: false);
    final data = await CartRepository.insert(newCart);

    if (data is CartModel) {
      await _recalculate(data);
      return;
    }

    emit(state.copyWith(status: CartStatus.error, error: ''));
    return;
  }

  Future updateItem(CartItemModel updated, int index) async {
    emit(state.copyWith(status: CartStatus.loading));

    CartModel cart =
    (index == -1) ? state.currentCart!.addItem(updated) : state.currentCart!.updateItem(updated, index);
    final newCart = await _recalculate(cart, emitStatus: false);

    final data = await CartRepository.update(newCart.uuid!, newCart.toJson());
    if (data is String) {
      emit(state.copyWith(status: CartStatus.error, error: data.toString()));
      return;
    }

    await _recalculate(newCart);
  }

  Future removeItem(int index) async {
    emit(state.copyWith(status: CartStatus.loading));

    CartModel cart = state.currentCart!;
    cart.items.removeAt(index);
    final newCart = await _recalculate(cart, emitStatus: false);

    final data = await CartRepository.delete(newCart.uuid!);
    if (data is String) {
      emit(state.copyWith(status: CartStatus.error, error: data.toString()));
      return;
    }

    await _recalculate(newCart);
  }

  Future<CartModel> _recalculate(CartModel cart, {bool emitStatus = true}) async {
    if (cart.items.isEmpty) {
      emit(const CartState(status: CartStatus.empty));
      _memory.cart = state;
    }

    CartModel newCart = CartModel.fromJson(cart.remap());

    final totalPrice = newCart.items.isNotEmpty ? newCart.items.map((e) => e.total).reduce((sum, el) => sum + el) : 0;
    newCart = newCart.copyWith(total: totalPrice.toDouble(), quantity: newCart.items.length, timestamp: DateTime.now());

    if (emitStatus) {
      emit(state.copyWith(
        status: newCart.items.isNotEmpty ? CartStatus.success : CartStatus.empty,
        cart: newCart.items.isNotEmpty ? newCart : CartModel(userUuid: newCart.userUuid),
      ));
      _memory.cart = state;
    }

    return newCart;
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) => CartState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toJson();
}
