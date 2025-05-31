import 'package:intl/intl.dart';

class CurrencyUtils {
  static String formatVND(num amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }

  static String formatNumber(num amount) {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return formatter.format(amount);
  }
}
