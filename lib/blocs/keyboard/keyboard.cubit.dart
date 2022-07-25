import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'keyboard.cubit.g.dart';

part 'keyboard.state.dart';

BlocProvider createKeyboardCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<KeyboardCubit>(
    create: (BuildContext context) => KeyboardCubit(),
    lazy: lazy,
  );
}

KeyboardCubit getKeyboardCubit(BuildContext context) {
  return BlocProvider.of<KeyboardCubit>(context, listen: false);
}

@JsonSerializable()
class KeyboardCubit extends HydratedCubit<KeyboardState> {
  KeyboardCubit() : super(KeyboardState());

  changeVisibility(bool status) {
    emit(state.copyWith(status: status ? KeyboardStatus.visible : KeyboardStatus.hidden));
  }

  @override
  KeyboardState? fromJson(Map<String, dynamic> json) => KeyboardState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(KeyboardState state) => state.toJson();
}
