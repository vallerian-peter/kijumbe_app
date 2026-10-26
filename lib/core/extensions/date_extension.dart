import '../helpers/date_formatter.dart';

/// Ergonomic extensions on [DateTime]
extension DateFormattingExtension on DateTime {
  /// Format date (e.g. dateTime.formatDate() -> "19 Sep 2026")
  String formatDate({String pattern = DateFormatter.defaultDateFormat, String? locale}) {
    return DateFormatter.formatDate(this, pattern: pattern, locale: locale);
  }

  /// Format date and time (e.g. dateTime.formatDateTime() -> "19 Sep 2026, 15:30")
  String formatDateTime({String pattern = DateFormatter.defaultDateTimeFormat, String? locale}) {
    return DateFormatter.formatDateTime(this, pattern: pattern, locale: locale);
  }

  /// Format time only (e.g. dateTime.formatTime() -> "03:30 PM")
  String formatTime({bool is24Hour = false}) {
    return DateFormatter.formatTime(this, is24Hour: is24Hour);
  }

  /// Format as numeric day/month/year (e.g. dateTime.formatDayMonthYear() -> "19/09/2026")
  String formatDayMonthYear() {
    return DateFormatter.formatDayMonthYear(this);
  }

  /// Format month and year (e.g. dateTime.formatMonthYear() -> "September 2026")
  String formatMonthYear({String? locale}) {
    return DateFormatter.formatMonthYear(this, locale: locale);
  }

  /// Relative human-readable time (e.g. "Just now", "5m ago", "Yesterday")
  String timeAgo({String? locale}) {
    return DateFormatter.timeAgo(this, locale: locale);
  }

  /// Check if date is today
  bool get isToday => DateFormatter.isToday(this);

  /// Check if date was yesterday
  bool get isYesterday => DateFormatter.isYesterday(this);

  /// Check if date is tomorrow
  bool get isTomorrow => DateFormatter.isTomorrow(this);
}
