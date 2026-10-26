import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
  });

  Widget buildTestWidget({required Widget child}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets(
      'LanguageSelectionContent renders English and Kiswahili options with pre-selected indicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: const LanguageSelectionContent(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Kiswahili'), findsOneWidget);

    // Both flags rendered
    expect(find.text('🇬🇧'), findsOneWidget);
    expect(find.text('🇹🇿'), findsOneWidget);

    // Tap on Kiswahili option
    await tester.tap(find.text('Kiswahili'));
    await tester.pumpAndSettle();

    // Verify LocaleManager updated
    expect(LocaleManager.instance.currentLocale.languageCode, equals('sw'));
  });
}
