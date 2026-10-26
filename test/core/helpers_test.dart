import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/helpers/helpers.dart';

void main() {
  group('NumberFormatter & Extensions', () {
    test('toThousands formats integers and decimals correctly', () {
      expect(NumberFormatter.toThousands(1000), '1,000');
      expect(NumberFormatter.toThousands(1000000), '1,000,000');
      expect(NumberFormatter.toThousands(1250.75), '1,250.75');
      expect(10000.toThousands(), '10,000');
      expect(500000.toCurrency(symbol: 'TZS'), 'TZS 500,000');
    });

    test('formatCompact formats numbers compactly', () {
      expect(1500.toCompact(), '1.5K');
      expect(2500000.toCompact(), '2.5M');
    });

    test('parseDouble and parseInt parse safely', () {
      expect(NumberFormatter.parseDouble('TZS 15,000.50'), 15000.50);
      expect(NumberFormatter.parseInt('15,000'), 15000);
      expect(NumberFormatter.parseDouble(null, defaultValue: 10.0), 10.0);
    });
  });

  group('DateFormatter & Extensions', () {
    test('formatDate formats DateTime as expected', () {
      final date = DateTime(2026, 9, 19, 14, 30);
      expect(date.formatDate(pattern: 'dd/MM/yyyy'), '19/09/2026');
      expect(date.formatDayMonthYear(), '19/09/2026');
      expect(date.formatTime(is24Hour: true), '14:30');
    });

    test('isToday, isYesterday, isTomorrow check correctly', () {
      final now = DateTime.now();
      expect(now.isToday, isTrue);
      expect(now.subtract(const Duration(days: 1)).isYesterday, isTrue);
      expect(now.add(const Duration(days: 1)).isTomorrow, isTrue);
    });

    test('timeAgo calculates relative time in English and Swahili', () {
      final now = DateTime.now();
      final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
      expect(fiveMinutesAgo.timeAgo(locale: 'en'), '5m ago');
      expect(fiveMinutesAgo.timeAgo(locale: 'sw'), 'Dakika 5 zilizopita');

      final justNow = now.subtract(const Duration(seconds: 10));
      expect(justNow.timeAgo(locale: 'en'), 'Just now');
      expect(justNow.timeAgo(locale: 'sw'), 'Sasa hivi');
    });
  });

  group('StringHelper & Extensions', () {
    test('capitalize and toTitleCase', () {
      expect('kijumbe'.capitalize(), 'Kijumbe');
      expect('member group contributions'.toTitleCase(), 'Member Group Contributions');
    });

    test('maskPhoneNumber and maskEmail', () {
      expect('+255712345678'.maskPhoneNumber(), '+255 712 *** 678');
      expect('emmanuel@example.com'.maskEmail(), 'e******l@example.com');
    });

    test('getInitials and sanitizePhoneNumber', () {
      expect('Emmanuel Ngallah'.getInitials(), 'EN');
      expect('0712345678'.sanitizePhoneNumber(), '+255712345678');
    });

    test('validation helpers', () {
      expect('test@example.com'.isValidEmail, isTrue);
      expect('invalid-email'.isValidEmail, isFalse);
      expect('+255712345678'.isValidPhone, isTrue);
      expect('12345'.isNumeric, isTrue);
      expect('abc'.isNumeric, isFalse);
    });
  });

  group('AppInfoHelper', () {
    test('getAppVersion returns fallback when platform channel not initialized', () async {
      final version = await AppInfoHelper.getAppVersion();
      expect(version.startsWith('v'), isTrue);
    });
  });
}
