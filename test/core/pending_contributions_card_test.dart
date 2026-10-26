import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/components/pending_contributions_card.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({required Widget child, bool isDark = false}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets(
      'PendingContributionsCard renders default localized title and member count',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      buildTestWidget(
        child: PendingContributionsCard(
          pendingCount: 3,
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PendingContributionsCard), findsOneWidget);
    expect(find.text('Pending Contributions'), findsOneWidget);
    expect(find.text('3 members have contributions due today'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.tap(find.byType(PendingContributionsCard));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets(
      'PendingContributionsCard supports custom title, subtitle, and dark mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        isDark: true,
        child: const PendingContributionsCard(
          title: 'Custom Urgent Alert',
          subtitle: 'Payment overdue by 2 days',
          isDark: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Custom Urgent Alert'), findsOneWidget);
    expect(find.text('Payment overdue by 2 days'), findsOneWidget);
  });
}
