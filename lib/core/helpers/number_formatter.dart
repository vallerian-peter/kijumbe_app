import 'package:intl/intl.dart';

/// Utility class for formatting numbers, currency, and financial figures
abstract class NumberFormatter {
  /// Format number with thousand separators (e.g. 10000 -> "10,000", 12500.5 -> "12,500.50")
  static String toThousands(
    num? number, {
    int? decimalDigits,
    String? locale,
  }) {
    if (number == null) return '0';

    final formatter = NumberFormat.currency(
      locale: locale ?? 'en_US',
      symbol: '',
      decimalDigits: decimalDigits ?? (number is int || number % 1 == 0 ? 0 : 2),
    );

    return formatter.format(number).trim();
  }

  /// Format amount with currency symbol (e.g. 50000 -> "TZS 50,000" or "$ 50,000")
  static String formatCurrency(
    num? amount, {
    String symbol = 'TZS',
    bool symbolAtStart = true,
    int? decimalDigits,
    String? locale,
  }) {
    if (amount == null) return symbolAtStart ? '$symbol 0' : '0 $symbol';

    final formattedNumber = toThousands(
      amount,
      decimalDigits: decimalDigits,
      locale: locale,
    );

    return symbolAtStart
        ? '$symbol $formattedNumber'
        : '$formattedNumber $symbol';
  }

  /// Format compact numbers (e.g. 1500 -> "1.5K", 2500000 -> "2.5M", 1000000000 -> "1B")
  static String formatCompact(num? number, {String? locale}) {
    if (number == null) return '0';
    final formatter = NumberFormat.compact(locale: locale ?? 'en_US');
    return formatter.format(number);
  }

  /// Format percentage (e.g. 0.15 -> "15%", 12.5 -> "12.5%")
  static String formatPercentage(
    num? value, {
    bool isDecimalRatio = false,
    int decimalDigits = 1,
  }) {
    if (value == null) return '0%';
    final num rate = isDecimalRatio ? value * 100 : value;
    final formatted = rate % 1 == 0 ? rate.toInt().toString() : rate.toStringAsFixed(decimalDigits);
    return '$formatted%';
  }

  /// Safely parse dynamic value or String to double without throwing an exception
  static double parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove currency symbols, commas, and spaces
      final cleanStr = value.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleanStr) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse dynamic value or String to int without throwing an exception
  static int parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final cleanStr = value.replaceAll(RegExp(r'[^\d-]'), '');
      return int.tryParse(cleanStr) ?? defaultValue;
    }
    return defaultValue;
  }
}
