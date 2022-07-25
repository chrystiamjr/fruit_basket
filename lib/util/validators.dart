bool isNullOrEmpty(dynamic value) {
  switch (value.runtimeType) {
    case String:
      return value
          .toString()
          .isEmpty || value.toString() == 'null' || value.toString() == '[]';
    case List:
      return value.length == 0 || value == [];
    case int:
    case double:
      return double.tryParse(value.toString()) == null;
    default:
      return value == null;
  }
}

String validateCodeErrors(String error) {
  switch (error) {
  // Firestore
    case 'permission-denied':
      return 'You do not have enough permission to access this information';
    case 'not-found':
      return 'The required information could not be found';

  // Auth
    case 'network-request-failed':
      return 'A network error (such as timeout, interrupted connection or unreachable host) has occurred';
    case 'weak-password':
      return 'The provided password is too weak';
    case 'email-already-in-use':
      return 'An account already exists for that email';
    case 'user-not-found':
      return 'No credentials found for that email';
    case 'wrong-password':
      return 'Wrong password provided for that user';

  // Unknown
    default:
      return 'Error: $error';
  }
}

bool isTextNumeric(String value) => isNullOrEmpty(value) ? false : double.tryParse(value) != null;

bool isValidEmail(String email) =>
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(email);
