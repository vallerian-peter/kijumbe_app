import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
  });

  testWidgets('GetStartedScreen renders orbit, 6 satellite icons, headline, and buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocales.supportedLocales,
        home: GetStartedScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Verify headline is rendered
    expect(
      find.text('Save Together.\nReceive With Confidence.'),
      findsOneWidget,
    );

    // Verify subtitle is rendered
    expect(
      find.text('Explore how Kijumbe works, track group savings insights, and launch your own circle in minutes.'),
      findsOneWidget,
    );

    // Verify primary and secondary CustomButons
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
    expect(find.byType(CustomButon), findsNWidgets(2));

    // Verify 6 satellite icon images + 1 center moneyBag hero
    expect(find.byType(Image), findsNWidgets(7));
    final images = tester.widgetList<Image>(find.byType(Image));
    final assetImages = images.where((img) => img.image is AssetImage).toList();
    expect(
      assetImages.any((img) => (img.image as AssetImage).assetName == AppAssets.moneyBag),
      isTrue,
    );
  });
}
