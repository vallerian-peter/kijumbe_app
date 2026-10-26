import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
  });

  testWidgets('LoginPhoneScreen renders phone number input and continue button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocales.supportedLocales,
        home: LoginPhoneScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Subtitle are rendered
    expect(find.text('Login to Your Account'), findsOneWidget);
    expect(find.text('Enter your credentials to login to our Kijumbe app.'), findsOneWidget);

    // Verify Phone number input field is rendered
    expect(find.byType(CustomPhoneNumberField), findsOneWidget);

    // Verify Continue button is rendered
    expect(find.text('Continue'), findsOneWidget);

    // Verify Register link is rendered
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text('Register here'), findsOneWidget);
  });

  testWidgets('LoginPasswordScreen renders password input and login button with terms checkbox',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocales.supportedLocales,
        home: LoginPasswordScreen(phoneNumber: '+255 712 345 678'),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Phone number subtitle are rendered
    expect(find.text('Login to Your Account'), findsOneWidget);
    expect(find.text('+255 712 345 678'), findsOneWidget);

    // Verify Password input field
    expect(find.text('Password'), findsOneWidget);

    // Verify Remember Me and Forgot Password
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Verify Terms and conditions checkbox is rendered
    expect(
      find.byWidgetPredicate((widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Terms & Conditions')),
      findsOneWidget,
    );

    // Verify Login button
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register here'), findsOneWidget);
  });
}
