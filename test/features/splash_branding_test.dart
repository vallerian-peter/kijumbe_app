import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/onboarding/onboarding.dart';

void main() {
  testWidgets('SplashBranding renders logo, app name, and tagline with animation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SplashBranding(
              appName: 'Kijumbe',
              appTagline: 'Save Together, Grow Together',
            ),
          ),
        ),
      ),
    );

    // Initial frame
    expect(find.byType(SplashBranding), findsOneWidget);
    expect(find.text('Kijumbe'), findsOneWidget);
    expect(find.text('Save Together, Grow Together'), findsOneWidget);

    // Forward through staggered animations
    await tester.pump(const Duration(milliseconds: 700));
    final splashScope = find.byType(SplashBranding);
    expect(find.descendant(of: splashScope, matching: find.byType(FadeTransition)), findsWidgets);
    expect(find.descendant(of: splashScope, matching: find.byType(ScaleTransition)), findsOneWidget);
    expect(find.descendant(of: splashScope, matching: find.byType(SlideTransition)), findsNWidgets(2));

    // Complete animation
    await tester.pump(const Duration(milliseconds: 800));
  });

  testWidgets('SplashBranding renders localized tagline in English by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocales.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SplashBranding(
              appName: 'Kijumbe',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SplashBranding), findsOneWidget);
    expect(find.text('Kijumbe'), findsOneWidget);
    expect(find.text('Save Together, Grow Together'), findsOneWidget);
  });

  testWidgets('SplashBranding renders localized tagline in Swahili',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('sw'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocales.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SplashBranding(
              appName: 'Kijumbe',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SplashBranding), findsOneWidget);
    expect(find.text('Kijumbe'), findsOneWidget);
    expect(find.text('Weka Akiba Pamoja, Tukue Pamoja'), findsOneWidget);
  });
}

