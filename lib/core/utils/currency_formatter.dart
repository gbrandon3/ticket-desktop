import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _copFormat = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String format(num value) {
    return _copFormat.format(value);
  }
}
