import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fruit_basket/blocs/keyboard/keyboard.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/loader/loader.cubit.dart';
import 'package:fruit_basket/blocs/login/login.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/ui/scenes/login/page.dart';
import 'package:fruit_basket/ui/scenes/spash.dart';
import 'package:fruit_basket/util/firebase_options.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storage = await HydratedStorage.build(storageDirectory: await getTemporaryDirectory());
  await _initializeFirebase();
  await EasyLocalization.ensureInitialized();

  await _initializeMemory();
  SingletonMemory
      .getInstance()
      .storage = storage;

  FirebaseAuth.instance.userChanges().listen((User? user) async {
    if (user == null) {
      SingletonMemory
          .getInstance()
          .language = const LanguageState();
      SingletonMemory
          .getInstance()
          .login = const LoginState();
      SingletonMemory
          .getInstance()
          .products = const ProductState();
      SingletonMemory
          .getInstance()
          .storage
          .delete('pwd');
      SingletonMemory
          .getInstance()
          .storage
          .delete('jwt');
    } else {
      SingletonMemory
          .getInstance()
          .user = user;
      await storage.write('jwt', await user.getIdToken());
    }
  });

  HydratedBlocOverrides.runZoned(
        () =>
        runApp(EasyLocalization(
          supportedLocales: SingletonMemory
              .getInstance()
              .language
              .languages
              .map((e) => e.locale)
              .toList(),
          path: 'assets/i18n',
          fallbackLocale: const Locale('pt', 'BR'),
          child: const FruitBasket(),
        )),
    storage: storage,
  );
}

Future _initializeMemory() async {
  SingletonMemory
      .getInstance()
      .language = const LanguageState();
  SingletonMemory
      .getInstance()
      .login = const LoginState();
  SingletonMemory
      .getInstance()
      .products = const ProductState();
}

Future _initializeFirebase() async {
  await Firebase.initializeApp();

  // final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  const localHostString = '192.168.230.174';

  // FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);
  // await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);

  // // Use only on debug
  // if (kDebugMode) {
  //   // must run 'firebase emulators:start'
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // }
}

class FruitBasket extends StatelessWidget {
  const FruitBasket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Basket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          createLanguageCubit(context),
          createLoaderCubit(context),
          createLoginCubit(context),
          createKeyboardCubit(context),
        ],
        child: const Splash(),
      ),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
