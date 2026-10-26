import 'package:flutter/services.dart';

/// Formats 20-digit NIDA number into:
/// `YYYYMMDD-XXXXX-XXXXX-XX` (e.g. 20011229-16001-00001-23)
class NidaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extract only digits
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clampedDigits = digitsOnly.length > 20
        ? digitsOnly.substring(0, 20)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < clampedDigits.length; i++) {
      buffer.write(clampedDigits[i]);
      // Hyphen after 8th digit (YYYYMMDD)
      if (i == 7 && i != clampedDigits.length - 1) {
        buffer.write('-');
      }
      // Hyphen after 13th digit (8 + 5)
      else if (i == 12 && i != clampedDigits.length - 1) {
        buffer.write('-');
      }
      // Hyphen after 18th digit (8 + 5 + 5)
      else if (i == 17 && i != clampedDigits.length - 1) {
        buffer.write('-');
      }
    }

    final formatted = buffer.toString();

    // Preserve cursor position reasonably
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Helper to strip hyphens and get raw 20 digits
  static String unformat(String formatted) {
    return formatted.replaceAll(RegExp(r'\D'), '');
  }
}

/// Formats phone numbers into 3-digit groups (e.g. `712 345 678`), max 9 digits.
class PhoneNumberGroupingFormatter extends TextInputFormatter {
  final int maxDigits;

  const PhoneNumberGroupingFormatter({this.maxDigits = 9});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clamped = digitsOnly.length > maxDigits
        ? digitsOnly.substring(0, maxDigits)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < clamped.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(clamped[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String unformat(String formatted) {
    return formatted.replaceAll(RegExp(r'\D'), '');
  }
}
