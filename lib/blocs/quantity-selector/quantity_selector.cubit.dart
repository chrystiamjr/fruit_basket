import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quantity_selector.cubit.g.dart';

BlocProvider createQuantitySelectorCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<QuantitySelectorCubit>(
    create: (BuildContext context) => QuantitySelectorCubit(),
    lazy: lazy,
  );
}

QuantitySelectorCubit getQuantitySelectorCubit(BuildContext context) {
  return BlocProvider.of<QuantitySelectorCubit>(context, listen: false);
}

@JsonSerializable()
class QuantitySelectorCubit extends HydratedCubit<int> {
  QuantitySelectorCubit() : super(1);

  setValue(int val) {
    emit(val > 0 ? val : val);
  }

  Future<int> increment(int maxAllowed) async {
    final newState = state + 1;
    if (newState <= maxAllowed) {
      emit(newState);
      return newState;
    }

    return state;
  }

  Future<int> decrement() async {
    final newState = state - 1;
    if (newState >= 1) {
      emit(newState);
      return newState;
    }

    return state;
  }

  @override
  int? fromJson(Map<String, dynamic> json) => json['quantity'];

  @override
  Map<String, dynamic>? toJson(int state) => {'quantity': state};
}
