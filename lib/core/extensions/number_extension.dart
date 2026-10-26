import '../helpers/number_formatter.dart';

/// Ergonomic extensions on [num], [int], and [double]
extension NumberFormattingExtension on num {
  /// Format number with thousand separators (e.g. 10000.toThousands() -> "10,000")
  String toThousands({int? decimalDigits, String? locale}) {
    return NumberFormatter.toThousands(
      this,
      decimalDigits: decimalDigits,
      locale: locale,
    );
  }

  /// Format with currency symbol (e.g. 50000.toCurrency() -> "TZS 50,000")
  String toCurrency({
    String symbol = 'TZS',
    bool symbolAtStart = true,
    int? decimalDigits,
    String? locale,
  }) {
    return NumberFormatter.formatCurrency(
      this,
      symbol: symbol,
      symbolAtStart: symbolAtStart,
      decimalDigits: decimalDigits,
      locale: locale,
    );
  }

  /// Format compact number (e.g. 1500.toCompact() -> "1.5K", 2500000.toCompact() -> "2.5M")
  String toCompact({String? locale}) {
    return NumberFormatter.formatCompact(this, locale: locale);
  }

  /// Format as percentage (e.g. 15.toPercentage() -> "15%")
  String toPercentage({bool isDecimalRatio = false, int decimalDigits = 1}) {
    return NumberFormatter.formatPercentage(
      this,
      isDecimalRatio: isDecimalRatio,
      decimalDigits: decimalDigits,
    );
  }
}
