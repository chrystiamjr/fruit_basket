import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/ui/theme.dart';
import 'package:fruit_basket/util/helper_functions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loader.cubit.g.dart';

part 'loader.state.dart';

BlocProvider createLoaderCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<LoaderCubit>(
    create: (BuildContext context) => LoaderCubit(),
    lazy: lazy,
  );
}

LoaderCubit getLoaderCubit(BuildContext context) {
  return BlocProvider.of<LoaderCubit>(context, listen: false);
}

@JsonSerializable()
class LoaderCubit extends HydratedCubit<LoaderState> {
  LoaderCubit() : super(LoaderState());

  setLoading(bool value) {
    emit(state.copyWith(status: value ? LoaderStatus.loading : LoaderStatus.stopping));

    if (!value) {
      Future.delayed(const Duration(milliseconds: 250), () => emit(state.copyWith(status: LoaderStatus.idle)));
    }
  }

  displayMessage(BuildContext context, String? info, String? type) {
    emit(state.copyWith(status: LoaderStatus.stopping));
    displaySnackbar(
      context,
      info: info,
      type: type ?? Helper.infoBtn,
    );
  }

  @override
  LoaderState? fromJson(Map<String, dynamic> json) => LoaderState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LoaderState state) => state.toJson();
}
