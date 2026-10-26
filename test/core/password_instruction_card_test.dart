import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/components/password_instruction_card.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({required Widget child, bool isDark = false}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  testWidgets('PasswordInstructionCard renders with explicit flags',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const PasswordInstructionCard(
          hasMinLength: true,
          hasUppercase: false,
          hasNumber: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PasswordInstructionCard), findsOneWidget);
    expect(find.byType(PasswordRequirementItem), findsNWidgets(3));

    // Two requirements are met (minLength and number) -> 2 check icons
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
  });

  testWidgets(
      'PasswordInstructionCard automatically evaluates criteria from password string',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const PasswordInstructionCard(
          password: 'Password1',
          confirmPassword: 'Password1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PasswordInstructionCard), findsOneWidget);
    // 3 base items (minLength, uppercase, number) + 1 match item = 4 items
    expect(find.byType(PasswordRequirementItem), findsNWidgets(4));

    // All 4 criteria are met for 'Password1' with matching confirm
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(4));
  });

  testWidgets(
      'PasswordInstructionCard indicates password mismatch when confirm does not match',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const PasswordInstructionCard(
          password: 'Password1',
          confirmPassword: 'Mismatch',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 3 criteria met, match not met -> 3 check icons
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(3));
  });

  testWidgets('PasswordInstructionCard supports dark mode and custom titles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isDark: true,
        child: const PasswordInstructionCard(
          title: 'Custom Title',
          isDark: true,
          hasMinLength: true,
          hasUppercase: true,
          hasNumber: true,
          showLowercase: true,
          hasLowercase: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Custom Title'), findsOneWidget);
    expect(find.byType(PasswordRequirementItem), findsNWidgets(4));
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(4));
  });
}
