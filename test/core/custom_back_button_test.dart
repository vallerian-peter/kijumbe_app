import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/components/custom_back_button.dart';

void main() {
  testWidgets('CustomBackButton renders with default arrow icon and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CustomBackButton), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

    await tester.tap(find.byType(CustomBackButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('CustomBackButton pops navigator when onTap is not provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(56),
                        child: CustomBackButton(),
                      ),
                      body: Text('Second Screen'),
                    ),
                  ),
                );
              },
              child: const Text('Open Second'),
            ),
          ),
        ),
      ),
    );

    // Open second screen
    await tester.tap(find.text('Open Second'));
    await tester.pumpAndSettle();
    expect(find.text('Second Screen'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byType(CustomBackButton));
    await tester.pumpAndSettle();

    // Should be popped back to first screen
    expect(find.text('Second Screen'), findsNothing);
    expect(find.text('Open Second'), findsOneWidget);
  });
}
