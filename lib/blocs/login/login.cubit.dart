import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_basket/util/singleton_memory.dart';
import 'package:fruit_basket/util/validators.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'login.cubit.g.dart';

part 'login.state.dart';

BlocProvider createLoginCubit(BuildContext context, {bool lazy = true}) {
  return BlocProvider<LoginCubit>(
    create: (BuildContext context) => LoginCubit(),
    lazy: lazy,
  );
}

LoginCubit getLoginCubit(BuildContext context) {
  return BlocProvider.of<LoginCubit>(context, listen: false);
}

@JsonSerializable()
class LoginCubit extends HydratedCubit<LoginState> {
  final _instance = FirebaseAuth.instance;

  LoginCubit() : super(SingletonMemory
      .getInstance()
      .login);

  Future asyncEmit(LoginState newState) async {
    emit(newState);
  }

  onchangeField({required LoginFields field, String val = ''}) {
    if (field.isEmail) _emitLoginSuccess(email: val);
    if (field.isPassword) _emitLoginSuccess(password: val);
    if (field.isConfirmation) _emitLoginSuccess(confirmation: val);
  }

  Future signin() async {
    emit(state.copyWith(status: LoginStatus.loading));

    if (await _validateFormField(state.emailText, 'E-mail field can not be empty')) return;
    if (await _validateFormField(state.passwordText, 'Password field can not be empty')) return;

    return await _signinWithEmail(email: state.emailText, password: state.passwordText);
  }

  signup() async {
    emit(state.copyWith(status: LoginStatus.loading));

    if (await _validateFormField(state.emailText, 'E-mail field can not be empty')) return;
    if (await _validateFormField(state.passwordText, 'Password field can not be empty')) return;
    if (await _validateFormField(state.confirmationText, 'Password confirmation field can not be empty')) return;

    if (state.passwordText != state.confirmationText) {
      await Future.delayed(const Duration(seconds: 1), () => _emitLoginError('Passwords are mismatched'));
      return;
    }

    return await _registerWithEmail(email: state.emailText, password: state.passwordText);
  }

  signout() async {
    if (_validateCredentials()) return;

    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _instance.signOut();
      _emitLoginSuccess(status: LoginStatus.initial);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'requires-recent-login') {
        await reauthenticate(emitStatus: false);
        return await signout();
      }
      print('FirebaseAuthException Error: $err');
      _emitLoginError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitLoginError(err.toString());
    }
  }

  reauthenticate({bool emitStatus = true}) async {
    if (_validateCredentials()) return;

    if (emitStatus) emit(state.copyWith(status: LoginStatus.loading));
    try {
      final memory = SingletonMemory.getInstance();
      String pwd = memory.storage.read('pwd');
      User? user = memory.user;

      return await _signinWithEmail(email: user!.email!, password: pwd);
    } on FirebaseAuthException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitLoginError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitLoginError(err.toString());
    }
  }

  updateUser({
    required String displayName,
    required String photoUrl,
    required String email,
    String? password,
  }) async {
    if (_validateCredentials(checkUIserLogged: true)) return;
    User currentUser = state.credential!.user!;

    emit(state.copyWith(status: LoginStatus.loading));
    try {
      if (currentUser.displayName != displayName) {
        await currentUser.updateDisplayName(displayName);
      }

      if (currentUser.photoURL != photoUrl) {
        await currentUser.updatePhotoURL(photoUrl);
      }

      if (currentUser.email != email) {
        await currentUser.updateEmail(displayName);
      }

      if (password != null) {
        await currentUser.updatePassword(password);
      }

      await await reauthenticate(emitStatus: false);
      _emitLoginSuccess(status: LoginStatus.loading);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'requires-recent-login') {
        await reauthenticate(emitStatus: false);
        return await updateUser(
          displayName: displayName,
          photoUrl: photoUrl,
          email: email,
          password: password,
        );
      }
      print('FirebaseAuthException Error: $err');
      _emitLoginError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitLoginError(err.toString());
    }
  }

  _validateFormField(String field, String error) async {
    if (field.isEmpty) {
      await Future.delayed(const Duration(seconds: 1), () => _emitLoginError(error));
      return true;
    }
    return false;
  }

  _signinWithEmail({
    required String email,
    required String password,
  }) async {
    if (_validateCredentials(checkUIserLogged: true)) return;

    emit(state.copyWith(status: LoginStatus.loading));
    try {
      UserCredential credential = await _instance.signInWithEmailAndPassword(email: email, password: password);
      _emitLoginSuccess(credential: credential, status: LoginStatus.success);
      await Future.delayed(
        const Duration(seconds: 2),
            () => _emitLoginSuccess(status: LoginStatus.logged),
      );
    } on FirebaseAuthException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitLoginError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitLoginError(err.toString());
    }
  }

  _registerWithEmail({
    required String email,
    required String password,
  }) async {
    if (_validateCredentials(checkUIserLogged: true)) return;

    emit(state.copyWith(status: LoginStatus.loading));
    try {
      UserCredential credential = await _instance.createUserWithEmailAndPassword(email: email, password: password);
      _emitLoginSuccess(credential: credential);
    } on FirebaseAuthException catch (err) {
      print('FirebaseAuthException Error: $err');
      _emitLoginError(err.code);
    } catch (err) {
      print('Custom Error: $err');
      _emitLoginError(err.toString());
    }
  }

  _validateCredentials({bool checkUIserLogged = false}) {
    if (checkUIserLogged) {
      if (state.credential?.user != null) {
        _emitLoginError('User already logged in');
        return true;
      }
    } else {
      if (state.credential == null) {
        _emitLoginError('User is not logged in');
        return true;
      }

      if (state.credential!.user == null) {
        _emitLoginError('User not found in credentials');
        return true;
      }
    }

    return false;
  }

  _emitLoginSuccess({
    UserCredential? credential,
    LoginStatus? status,
    String? email,
    String? password,
    String? confirmation,
  }) {
    emit(state.copyWith(
      status: status,
      credential: credential,
      error: null,
      email: email,
      password: password,
      confirmation: confirmation,
    ));

    SingletonMemory
        .getInstance()
        .login = state;
  }

  _emitLoginError(String error) {
    emit(state.copyWith(
      status: LoginStatus.error,
      credential: null,
      error: validateCodeErrors(error),
      email: null,
      password: null,
      confirmation: null,
    ));
    SingletonMemory
        .getInstance()
        .login = state;
  }

  @override
  LoginState? fromJson(Map<String, dynamic> json) => LoginState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(LoginState state) => state.toJson();
}
