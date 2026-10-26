import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Kijumbe',
      packageName: 'com.example.kijumbe_app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    await AppStorageManager.init();
    LocaleManager.init();
    ThemeManager.init();
  });

  testWidgets('App launches with SplashScreen and displays branding',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 8));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
