import 'package:flutter/cupertino.dart';
import 'package:fruit_basket/blocs/language/language.cubit.dart';
import 'package:intl/intl.dart';

import 'validators.dart';

String dateFormatter(String dateString, {bool dateOnly = false, bool compressed = false, String pattern = ''}) {
  final String year = compressed ? 'yy' : 'yyyy';
  String layout = isNullOrEmpty(pattern) ? (dateOnly ? 'dd/MM/$year' : 'dd/MM/$year HH:mm') : pattern;
  return isNullOrEmpty(dateString) ? 'Não cadastrado' : DateFormat(layout).format(DateTime.parse(dateString));
}

String phoneFormatter(String? phoneNumberString) {
  if (isNullOrEmpty(phoneNumberString))
    return 'Não cadastrado';

  if (phoneNumberString![0] == '0') phoneNumberString = phoneNumberString.substring(1);

  final cleaned = phoneNumberString.replaceAll(RegExp(r"[^0-9]"), "");
  final cell = RegExp(r"^(1|)?(\d{2})(\d{5})(\d{4})", caseSensitive: false, multiLine: false);
  final home = RegExp(r"^(1|)?(\d{2})(\d{4})(\d{4})", caseSensitive: false, multiLine: false);
  final match = cleaned.length > 10 ? cell.firstMatch(cleaned) : home.firstMatch(cleaned);
  return !isNullOrEmpty(match) ? ['('
  , match![2], ') ', match[3], '-', match[4]].join('') :
  phoneNumberString;
}

String zipFormatter(int parameter) {
  String zipString = parameter.toString();
  if (isNullOrEmpty(zipString) || zipString.length < 3)
    return 'Não cadastrado';

  zipString = zipString.padRight(8, '0');
  final cleaned = zipString.replaceAll(RegExp(r"[^0-9]"), "");
  final zip = RegExp(r"^(\d{5})(\d{3})", caseSensitive: false, multiLine: false);
  final match = zip.firstMatch(cleaned);
  return !isNullOrEmpty(match) ? [match![1]
  , '-', match[2]].join
  (
  '
  '
  )
  :
  zipString;
}

String currencyFormatter(BuildContext context, {double price = 0}) {
  final currentLang = getLanguageCubit(context).state.currentLang;
  final isBr = currentLang?.name == 'pt_BR';
  if (isBr)
    price *= 5;

  final formatter = NumberFormat.simpleCurrency(locale: currentLang?.name ?? 'pt_BR');
  return formatter.format(price);
}

String capitalize(String str, {bool all = false}) =>
    all
        ? str.toUpperCase()
        : str.isEmpty
        ? ''
        : '${str[0].toUpperCase()}${str.substring(1)}';
