part of 'login.cubit.dart';

enum LoginStatus { initial, loading, success, error, logged }

extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;

  bool get isLoading => this == LoginStatus.loading;

  bool get isSuccess => this == LoginStatus.success;

  bool get isLogged => this == LoginStatus.logged;

  bool get isError => this == LoginStatus.error;
}

enum LoginFields { email, password, confirmation }

extension LoginStatusY on LoginFields {
  bool get isEmail => this == LoginFields.email;

  bool get isPassword => this == LoginFields.password;

  bool get isConfirmation => this == LoginFields.confirmation;
}

class LoginState extends Equatable {
  final LoginStatus status;
  final UserCredential? credential;
  final String? errorMessage;
  final String emailText;
  final String passwordText;
  final String confirmationText;

  const LoginState({
    this.status = LoginStatus.initial,
    this.credential,
    this.errorMessage,
    this.emailText = '',
    this.passwordText = '',
    this.confirmationText = '',
  });

  LoginState copyWith({
    LoginStatus? status,
    UserCredential? credential,
    String? error,
    String? email,
    String? password,
    String? confirmation,
  }) =>
      LoginState(
        status: status ?? this.status,
        credential: credential ?? this.credential,
        errorMessage: error ?? errorMessage,
        emailText: email ?? emailText,
        passwordText: password ?? passwordText,
        confirmationText: confirmation ?? confirmationText,
      );

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      LoginState(
        status: json['status'],
        credential: json['credential'],
        errorMessage: json['error'],
        emailText: json['email'],
        passwordText: json['password'],
        confirmationText: json['confirmation'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
        'credential': credential?.user?.refreshToken,
        'errorMessage': errorMessage,
        'emailText': emailText,
        'passwordText': passwordText,
        'confirmationText': confirmationText,
      };

  @override
  List<Object?> get props =>
      [
        status,
        credential,
        errorMessage,
        emailText,
        passwordText,
        confirmationText,
      ];
}
