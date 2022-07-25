import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fruit_basket/models/language.model.dart';
import 'package:fruit_basket/models/requests/geolocation.model.dart';
import 'package:fruit_basket/providers/map_quest.provider.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'language.cubit.g.dart';

part 'language.state.dart';

BlocProvider createLanguageCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<LanguageCubit>(
    create: (BuildContext context) => LanguageCubit(),
    lazy: lazy,
  );
}

LanguageCubit getLanguageCubit(BuildContext context) {
  return BlocProvider.of<LanguageCubit>(context, listen: false);
}

@JsonSerializable()
class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit() : super(SingletonMemory
      .getInstance()
      .language);

  getAvailableLanguages() {
    return state.languages;
  }

  changeLanguage(String tag, {LanguageStatus? status}) async {
    emit(state.copyWith(status: LanguageStatus.loading));

    var models = state.languages.where((lang) => lang.name == tag).toList();
    if (models.isEmpty) {
      models = state.languages.where((lang) => lang.name == 'pt_BR').toList();
    }

    LanguageModel model = models.first;
    emit(state.copyWith(
      status: status ?? state.status,
      currentLang: model,
    ));

    SingletonMemory
        .getInstance()
        .language = state;
  }

  Future<Object> getLanguageByLocation() async {
    emit(state.copyWith(status: LanguageStatus.loading));

    // changeLanguage('en_US', status: LanguageStatus.accepted);

    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    if (geolocationStatus == LocationPermission.always || geolocationStatus == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GeolocationModel model =
      await MapQuestProvider().getAddress(latLng: '${position.latitude},${position.longitude}');

      final isBR = model.results?[0].locations?[0].adminArea1 == 'BR';
      changeLanguage(isBR ? 'pt_BR' : 'en_US', status: LanguageStatus.accepted);
    } else {
      if (state.attempt == 0) {
        await Geolocator.requestPermission();
        return getLanguageByLocation();
      }

      if (state.attempt > 0) {
        changeLanguage('pt_BR', status: LanguageStatus.rejected);
      }
    }

    return state;
  }

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    return LanguageState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return state.toJson();
  }
}
