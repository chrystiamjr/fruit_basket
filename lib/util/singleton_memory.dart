import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_basket/blocs/cart/cart.cubit.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:fruit_basket/blocs/product/product.cubit.dart';
import 'package:fruit_basket/models/category.model.dart';
import 'package:fruit_basket/models/product.model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../blocs/login/login.cubit.dart';

class SingletonMemory {
  static SingletonMemory instance = SingletonMemory();

  static SingletonMemory getInstance() => instance;

  CartState cart = const CartState();
  LanguageState language = const LanguageState();
  ProductState products = const ProductState();
  LoginState login = const LoginState();
  PanelController slider = PanelController();

  late HydratedStorage storage;
  late User? user;

  late List<ProductModel> productList;
  late List<CategoryModel> categoryList;
}
