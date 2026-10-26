import 'package:intl/intl.dart';

/// Utility class for formatting, parsing, and calculating dates and times
abstract class DateFormatter {
  /// Default date format: "19 Sep 2026"
  static const String defaultDateFormat = 'dd MMM yyyy';

  /// Default date time format: "19 Sep 2026, 15:30"
  static const String defaultDateTimeFormat = 'dd MMM yyyy, HH:mm';

  /// Numeric date format: "19/09/2026"
  static const String numericDateFormat = 'dd/MM/yyyy';

  /// Format date to custom pattern (e.g. "19 Sep 2026")
  static String formatDate(
    DateTime? date, {
    String pattern = defaultDateFormat,
    String? locale,
  }) {
    if (date == null) return '';
    return DateFormat(pattern, locale).format(date);
  }

  /// Format date and time (e.g. "19 Sep 2026, 15:30")
  static String formatDateTime(
    DateTime? date, {
    String pattern = defaultDateTimeFormat,
    String? locale,
  }) {
    if (date == null) return '';
    return DateFormat(pattern, locale).format(date);
  }

  /// Format time only (e.g. "03:30 PM" or "15:30")
  static String formatTime(
    DateTime? date, {
    bool is24Hour = false,
  }) {
    if (date == null) return '';
    final pattern = is24Hour ? 'HH:mm' : 'hh:mm a';
    return DateFormat(pattern).format(date);
  }

  /// Format as numeric day/month/year (e.g. "19/09/2026")
  static String formatDayMonthYear(DateTime? date) {
    if (date == null) return '';
    return DateFormat(numericDateFormat).format(date);
  }

  /// Format month and year (e.g. "September 2026")
  static String formatMonthYear(DateTime? date, {String? locale}) {
    if (date == null) return '';
    return DateFormat('MMMM yyyy', locale).format(date);
  }

  /// Human-readable relative time (e.g. "Just now", "5m ago", "2h ago", "Yesterday", "3d ago")
  /// Supports English and Swahili ('sw')
  static String timeAgo(DateTime? date, {String? locale}) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);
    final isSwahili = locale?.toLowerCase().startsWith('sw') ?? false;

    if (difference.inSeconds < 45) {
      return isSwahili ? 'Sasa hivi' : 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return isSwahili
          ? 'Dakika $minutes zilizopita'
          : '${minutes}m ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return isSwahili
          ? 'Saa $hours zilizopita'
          : '${hours}h ago';
    } else if (difference.inDays == 1 || isYesterday(date)) {
      return isSwahili ? 'Jana' : 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return isSwahili
          ? 'Siku $days zilizopita'
          : '${days}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return isSwahili
          ? 'Wiki $weeks zilizopita'
          : '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return isSwahili
          ? 'Miezi $months iliyopita'
          : '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return isSwahili
          ? 'Miaka $years iliyopita'
          : '${years}y ago';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if date was yesterday
  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime? date) {
    if (date == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Safely parse String to DateTime without throwing
  static DateTime? tryParse(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    return DateTime.tryParse(dateStr);
  }
}
