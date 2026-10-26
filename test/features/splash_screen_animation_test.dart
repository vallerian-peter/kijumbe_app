import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:kijumbe_app/features/onboarding/presentation/widgets/splash_branding.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Kijumbe',
      packageName: 'com.example.kijumbe_app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    await AppStorageManager.init();
  });

  Widget buildSplashScreen({
    Duration brandingDuration = const Duration(milliseconds: 600),
    Duration loadingDelay = const Duration(milliseconds: 800),
    Duration navigationDelay = const Duration(milliseconds: 2000),
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocales.supportedLocales,
      home: SplashScreen(
        brandingDuration: brandingDuration,
        loadingDelay: loadingDelay,
        navigationDelay: navigationDelay,
      ),
    );
  }

  testWidgets('SplashScreen displays Version immediately with NO delay', (WidgetTester tester) async {
    await tester.pumpWidget(buildSplashScreen());

    // From frame 0, version text must be visible
    final versionFinder = find.byKey(const Key('splash_version_text'));
    expect(versionFinder, findsOneWidget);

    final Text versionWidget = tester.widget(versionFinder);
    expect(versionWidget.data, contains('App Version:'));

    // Loading indicator is initially invisible (opacity 0)
    final AnimatedOpacity initialLoaderOpacity = tester.widget(
      find.ancestor(
        of: find.byKey(const Key('splash_loading_indicator')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(initialLoaderOpacity.opacity, equals(0.0));

    // Allow timers to complete
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Loading indicator delays by specified duration after branding completes', (WidgetTester tester) async {
    const brandingDuration = Duration(milliseconds: 400);
    const loadingDelay = Duration(milliseconds: 600);
    const navigationDelay = Duration(milliseconds: 3000);

    await tester.pumpWidget(
      buildSplashScreen(
        brandingDuration: brandingDuration,
        loadingDelay: loadingDelay,
        navigationDelay: navigationDelay,
      ),
    );

    // Initial frame: branding rendered with SplashBranding
    expect(find.byType(SplashBranding), findsOneWidget);

    // Advance through branding duration and trigger status listener
    await tester.pump(brandingDuration);
    await tester.pump();

    // Branding has completed, but loading delay has not elapsed yet (opacity still 0.0)
    AnimatedOpacity loaderOpacity = tester.widget(
      find.ancestor(
        of: find.byKey(const Key('splash_loading_indicator')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(loaderOpacity.opacity, equals(0.0));

    // Advance through the loadingDelay
    await tester.pump(loadingDelay);
    // Advance for AnimatedOpacity animation
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    // Loading indicator is now visible
    loaderOpacity = tester.widget(
      find.ancestor(
        of: find.byKey(const Key('splash_loading_indicator')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(loaderOpacity.opacity, equals(1.0));

    // Complete navigation timer
    await tester.pump(const Duration(milliseconds: 2000));
  });
}
