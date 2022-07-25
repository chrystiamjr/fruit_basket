import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/models/category.model.dart';
import 'package:fruit_basket/repositories/categories.repository.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:fruit_basket/util/validators.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'category.cubit.g.dart';

part 'category.state.dart';

BlocProvider createCategoryCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<CategoryCubit>(
    create: (BuildContext context) => CategoryCubit(),
    lazy: lazy,
  );
}

CategoryCubit getCategoryCubit(BuildContext context) {
  return BlocProvider.of<CategoryCubit>(context, listen: false);
}

@JsonSerializable()
class CategoryCubit extends HydratedCubit<CategoryState> {
  final _memory = SingletonMemory.getInstance();

  CategoryCubit() : super(CategoryState());

  Future getCategories() async {
    _emitPositiveState(status: CategoryStatus.loading);

    try {
      final snapshots = await CategoriesRepository.getAll();
      final models = snapshots.map((e) => e.data()).toList();
      _emitPositiveState(
        status: CategoryStatus.success,
        categories: models,
      );
    } on FirebaseException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitError(err.toString());
    }
  }

  Future changeSelected(int index) async {
    _emitPositiveState(status: CategoryStatus.loading);
    _emitPositiveState(status: CategoryStatus.success, index: index);
  }

  Future redefineSelection() async {
    _emitPositiveState(status: CategoryStatus.loading);
    _emitPositiveState(status: CategoryStatus.success, index: -1);
  }

  _emitPositiveState({
    CategoryStatus? status,
    int? index,
    List<CategoryModel>? categories,
  }) {
    emit(state.copyWith(
      status: status,
      index: index,
      items: categories ?? [],
      error: null,
    ));

    if (categories != null) _memory.categoryList = categories;
  }

  _emitError(String error) {
    emit(state.copyWith(
      status: CategoryStatus.error,
      index: -1,
      items: null,
      error: validateCodeErrors(error),
    ));

    _memory.categoryList = [];
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) => CategoryState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CategoryState state) => state.toJson();
}
