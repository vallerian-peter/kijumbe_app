import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/components/custom_button.dart';
import 'package:kijumbe_app/core/utils/colors.dart';

void main() {
  group('CustomButon Widget Tests', () {
    testWidgets('renders filled button with text and triggers callback', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.text('Click Me'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('renders outlined button with CustomButon.outlined', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon.outlined(
              text: 'Outline Button',
              borderColor: Colors.teal,
              textColor: Colors.teal,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Outline Button'), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = elevatedButton.style?.shape?.resolve({}) as RoundedRectangleBorder?;
      expect(shape?.side.color, Colors.teal);

      await tester.tap(find.text('Outline Button'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('renders outlined button via isOutlined: true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Outlined Flag',
              isOutlined: true,
              borderColor: Colors.purple,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined Flag'), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = elevatedButton.style?.shape?.resolve({}) as RoundedRectangleBorder?;
      expect(shape?.side.color, Colors.purple);
    });

    testWidgets('shows loading indicator when isLoading is true and disables tap', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Loading...',
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);

      await tester.tap(find.byType(CustomButon));
      await tester.pump();
      expect(pressed, isFalse);
    });

    testWidgets('renders prefix and suffix icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'With Icons',
              prefixIcon: const Icon(Icons.star),
              suffixIcon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('With Icons'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders gradient button via gradient parameter', (tester) async {
      var pressed = false;
      const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Gradient Button',
              gradient: gradient,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Gradient Button'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.gradient, gradient);

      await tester.tap(find.text('Gradient Button'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('renders gradient button via CustomButon.gradient constructor', (tester) async {
      const gradient = LinearGradient(colors: [Colors.green, Colors.teal]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon.gradient(
              text: 'Named Gradient',
              gradient: gradient,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Named Gradient'), findsOneWidget);
    });

    testWidgets('default button uses primaryButtonGradient shine', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Default Shiny',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Default Shiny'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.gradient, AppColors.primaryButtonGradient);
    });

    testWidgets('explicit solid bgColor button does not use gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon(
              text: 'Solid Color',
              bgColor: Colors.red,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Solid Color'), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.style?.backgroundColor?.resolve({}), Colors.red);
    });

    testWidgets('outlined button defaults to transparent background without gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButon.outlined(
              text: 'Transparent Outline',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Transparent Outline'), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.style?.backgroundColor?.resolve({}), Colors.transparent);
    });
  });
}
