/// Utility class for form inputs and business validation logic
abstract class ValidatorHelper {
  /// Regular expression for validating standard email addresses
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Regular expression for phone numbers (supports international + or local digits)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[0-9]{9,15}$',
  );

  /// Check if email format is valid
  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Check if phone number format is valid
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return false;
    final clean = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    return _phoneRegex.hasMatch(clean);
  }

  /// Check if password meets minimum length
  static bool hasMinLength(String? password, {int minLength = 6}) {
    return password != null && password.length >= minLength;
  }

  /// Check if password contains at least one uppercase letter
  static bool hasUppercase(String? password) {
    return password != null && RegExp(r'[A-Z]').hasMatch(password);
  }

  /// Check if password contains at least one lowercase letter
  static bool hasLowercase(String? password) {
    return password != null && RegExp(r'[a-z]').hasMatch(password);
  }

  /// Check if password contains at least one number
  static bool hasNumber(String? password) {
    return password != null && RegExp(r'\d').hasMatch(password);
  }

  /// Check if password contains at least one special character
  static bool hasSpecialChar(String? password) {
    return password != null && RegExp(r'[@$!%*?&._#-]').hasMatch(password);
  }

  /// Check if password meets required password rules (length >= 6, uppercase, number)
  static bool isStrongPassword(String? password, {int minLength = 6}) {
    return hasMinLength(password, minLength: minLength) &&
        hasUppercase(password) &&
        hasNumber(password);
  }

  /// Legacy alias for basic password check
  static bool isValidPassword(String? password, {int minLength = 6}) {
    return hasMinLength(password, minLength: minLength);
  }

  /// Check if string is a valid positive financial amount
  static bool isValidAmount(
    String? amount, {
    double minAmount = 1.0,
    double? maxAmount,
  }) {
    if (amount == null || amount.trim().isEmpty) return false;
    final clean = amount.replaceAll(RegExp(r'[^\d.]'), '');
    final val = double.tryParse(clean);
    if (val == null || val < minAmount) return false;
    if (maxAmount != null && val > maxAmount) return false;
    return true;
  }

  /// Check if string contains only numeric digits
  static bool isNumeric(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return RegExp(r'^\d+$').hasMatch(value.trim());
  }
}
