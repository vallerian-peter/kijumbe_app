import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/helpers/helpers.dart';

void main() {
  test('NidaInputFormatter formats digits correctly', () {
    final formatter = NidaInputFormatter();
    const input = TextEditingValue(text: '20011229160010000123');
    final formatted = formatter.formatEditUpdate(TextEditingValue.empty, input);
    expect(formatted.text, '20011229-16001-00001-23');
    expect(NidaInputFormatter.unformat(formatted.text), '20011229160010000123');
  });

  test('PhoneNumberGroupingFormatter groups digits into 3s', () {
    const formatter = PhoneNumberGroupingFormatter(maxDigits: 10);
    const input = TextEditingValue(text: '712345678');
    final formatted = formatter.formatEditUpdate(TextEditingValue.empty, input);
    expect(formatted.text, '712 345 678');
  });

  testWidgets('CustomAlertBox renders with type icon and message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomAlertBox(
            type: AlertType.warning,
            title: 'Attention',
            message: 'Please review before proceeding',
          ),
        ),
      ),
    );

    expect(find.text('Attention'), findsOneWidget);
    expect(find.text('Please review before proceeding'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('CustomOtpInput renders 6 pin fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomOtpInput(
            length: 6,
          ),
        ),
      ),
    );

    expect(find.byType(CustomOtpInput), findsOneWidget);
  });
}
