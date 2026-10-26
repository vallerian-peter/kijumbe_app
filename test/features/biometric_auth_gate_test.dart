import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:kijumbe_app/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
  });

  group('Biometric Storage Preference Tests', () {
    test('default biometric preference is false', () {
      expect(AppStorageManager.instance.isBiometricAuthEnabled(), isFalse);
    });

    test('can set and retrieve biometric preference', () async {
      await AppStorageManager.instance.setBiometricAuthEnabled(true);
      expect(AppStorageManager.instance.isBiometricAuthEnabled(), isTrue);

      await AppStorageManager.instance.setBiometricAuthEnabled(false);
      expect(AppStorageManager.instance.isBiometricAuthEnabled(), isFalse);
    });
  });

  group('AuthGate Widget Tests', () {
    testWidgets('AuthGate navigates to GetStartedScreen when biometric is disabled',
        (WidgetTester tester) async {
      await AppStorageManager.instance.setBiometricAuthEnabled(false);

      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocales.supportedLocales,
          home: AuthGate(),
        ),
      );

      // Advance frames for postFrameCallback and navigation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Should have navigated to GetStartedScreen
      expect(find.byType(GetStartedScreen), findsOneWidget);
    });
  });
}
