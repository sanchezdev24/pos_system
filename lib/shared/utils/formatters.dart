import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';

class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'es_MX',
    symbol: AppConstants.currency,
    decimalDigits: 2,
  );

  static final _dateFormat = DateFormat(AppConstants.dateFormat, 'es_MX');
  static final _dateOnlyFormat = DateFormat(AppConstants.dateOnlyFormat, 'es_MX');

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateOnly(DateTime date) {
    return _dateOnlyFormat.format(date);
  }

  static String formatQuantity(int quantity) {
    return quantity.toString();
  }
}