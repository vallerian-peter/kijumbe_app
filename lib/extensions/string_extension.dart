import 'package:kijumbe_app/helpers/helpers.dart';

/// Ergonomic extensions on [String]
extension StringFormattingExtension on String {
  /// Capitalize first character ("kijumbe" -> "Kijumbe")
  String capitalize() => StringHelper.capitalize(this);

  /// Convert to Title Case ("member group" -> "Member Group")
  String toTitleCase() => StringHelper.toTitleCase(this);

  /// Mask phone number for privacy ("+255712345678" -> "+255 712 *** 678")
  String maskPhoneNumber() => StringHelper.maskPhoneNumber(this);

  /// Mask email for privacy ("user@example.com" -> "u***r@example.com")
  String maskEmail() => StringHelper.maskEmail(this);

  /// Extract initials ("Emmanuel Ngallah" -> "EN")
  String getInitials({int limit = 2}) => StringHelper.getInitials(this, limit: limit);

  /// Truncate with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) =>
      StringHelper.truncate(this, maxLength, ellipsis: ellipsis);

  /// Sanitize phone number to standard international format
  String sanitizePhoneNumber({String defaultCountryCode = '+255'}) =>
      StringHelper.sanitizePhoneNumber(this, defaultCountryCode: defaultCountryCode);

  /// Check if valid email
  bool get isValidEmail => ValidatorHelper.isValidEmail(this);

  /// Check if valid phone
  bool get isValidPhone => ValidatorHelper.isValidPhone(this);

  /// Check if numeric
  bool get isNumeric => ValidatorHelper.isNumeric(this);

  /// Try parse to DateTime
  DateTime? get toDateTime => DateFormatter.tryParse(this);
}
