/// Utility class for string manipulation, masking, sanitizing, and formatting
abstract class StringHelper {
  /// Capitalize first character of string (e.g. "kijumbe" -> "Kijumbe")
  static String capitalize(String? text) {
    if (text == null || text.trim().isEmpty) return '';
    final trimmed = text.trim();
    if (trimmed.length == 1) return trimmed.toUpperCase();
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  /// Convert to Title Case (e.g. "member group contribution" -> "Member Group Contribution")
  static String toTitleCase(String? text) {
    if (text == null || text.trim().isEmpty) return '';
    return text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => capitalize(word))
        .join(' ');
  }

  /// Mask a phone number for privacy (e.g. "+255712345678" -> "+255 712 *** 678")
  static String maskPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 7) return clean;

    // Formats e.g. +255712345678 -> +255 712 *** 678
    if (clean.startsWith('+') && clean.length >= 12) {
      final countryCode = clean.substring(0, 4);
      final prefix = clean.substring(4, 7);
      final end = clean.substring(clean.length - 3);
      return '$countryCode $prefix *** $end';
    }

    final start = clean.substring(0, clean.length - 6);
    final end = clean.substring(clean.length - 3);
    return '$start *** $end';
  }

  /// Mask an email for privacy (e.g. "user@example.com" -> "u***r@example.com")
  static String maskEmail(String? email) {
    if (email == null || !email.contains('@')) return email ?? '';
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '${name[0]}*@$domain';
    }

    final maskedName = '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}';
    return '$maskedName@$domain';
  }

  /// Extract initials from a full name (e.g. "Emmanuel Ngallah" -> "EN", "Kijumbe" -> "K")
  static String getInitials(String? name, {int limit = 2}) {
    if (name == null || name.trim().isEmpty) return '';
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < words.length && i < limit; i++) {
      buffer.write(words[i][0].toUpperCase());
    }
    return buffer.toString();
  }

  /// Truncate long text with ellipsis (e.g. "Very long description..." with maxLength = 10 -> "Very long...")
  static String truncate(String? text, int maxLength, {String ellipsis = '...'}) {
    if (text == null) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  /// Sanitize and format phone number (e.g. "0712345678" -> "+255712345678")
  static String sanitizePhoneNumber(
    String? phone, {
    String defaultCountryCode = '+255',
  }) {
    if (phone == null || phone.trim().isEmpty) return '';
    var clean = phone.replaceAll(RegExp(r'[\s\-()]'), '');

    if (clean.startsWith('0')) {
      clean = '$defaultCountryCode${clean.substring(1)}';
    } else if (!clean.startsWith('+')) {
      clean = '+$clean';
    }

    return clean;
  }
}
