import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'cart_detail.cubit.g.dart';

part 'cart_detail.state.dart';

BlocProvider createCartDetailCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<CartDetailCubit>(
    create: (BuildContext context) => CartDetailCubit(),
    lazy: lazy,
  );
}

CartDetailCubit getCartDetailCubit(BuildContext context) {
  return BlocProvider.of<CartDetailCubit>(context, listen: false);
}

@JsonSerializable()
class CartDetailCubit extends HydratedCubit<CartDetailState> {
  CartDetailCubit() : super(CartDetailState());

  closeDetail() {
    emit(state.copyWith(status: CartDetailStatus.hidden));
  }

  openDetail() {
    emit(state.copyWith(status: CartDetailStatus.shown));
  }

  @override
  CartDetailState? fromJson(Map<String, dynamic> json) => CartDetailState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartDetailState state) => state.toJson();
}
