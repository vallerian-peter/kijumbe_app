import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';

void main() {
  group('CustomTextField Theme Management Tests', () {
    testWidgets('respects isDark: true with dark background and text styles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(), // Ambient light theme
          home: const Scaffold(
            body: CustomTextField(
              label: 'Password',
              hintText: 'Enter password',
              isDark: true,
            ),
          ),
        ),
      );

      final textFinder = find.byType(TextFormField);
      expect(textFinder, findsOneWidget);

      final textField = tester.widget<TextField>(
        find.descendant(
          of: textFinder,
          matching: find.byType(TextField),
        ),
      );
      expect(textField.style?.color, Colors.white);

      final inputDecorator = tester.widget<InputDecorator>(
        find.descendant(
          of: textFinder,
          matching: find.byType(InputDecorator),
        ),
      );
      expect(inputDecorator.decoration.fillColor, const Color(0xFF1E2226));
      expect(inputDecorator.decoration.hintStyle?.color, Colors.white38);

      final labelFinder = find.text('Password');
      expect(labelFinder, findsOneWidget);
      final labelWidget = tester.widget<Text>(labelFinder);
      expect(labelWidget.style?.color, Colors.white70);
    });

    testWidgets('allows overriding bgColor and custom text colors',
        (WidgetTester tester) async {
      const customBg = Color(0xFF123456);
      const customText = Colors.yellow;
      const customLabel = Colors.cyan;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Custom Field',
              bgColor: customBg,
              textColor: customText,
              labelColor: customLabel,
            ),
          ),
        ),
      );

      final textFinder = find.byType(TextFormField);
      final textField = tester.widget<TextField>(
        find.descendant(
          of: textFinder,
          matching: find.byType(TextField),
        ),
      );
      expect(textField.style?.color, customText);

      final inputDecorator = tester.widget<InputDecorator>(
        find.descendant(
          of: textFinder,
          matching: find.byType(InputDecorator),
        ),
      );
      expect(inputDecorator.decoration.fillColor, customBg);

      final labelWidget = tester.widget<Text>(find.text('Custom Field'));
      expect(labelWidget.style?.color, customLabel);
    });
  });
}
