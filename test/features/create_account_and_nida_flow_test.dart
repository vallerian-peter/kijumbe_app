import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart' hide PasswordRequirementItem;
import 'package:kijumbe_app/features/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
  });

  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocales.supportedLocales,
      home: child,
    );
  }

  group('CreateAccountScreen Tests', () {
    testWidgets('renders phone number input, password fields, and continue button in English',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const CreateAccountScreen()));
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('Create Your Account'), findsOneWidget);
      expect(
        find.text("Let's get you started with Kijumbe, where all Group Savings and Tracking happens."),
        findsOneWidget,
      );

      // Phone field (replaces email)
      expect(find.byType(CustomPhoneNumberField), findsOneWidget);

      // Password field and criteria
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(PasswordRequirementItem), findsNWidgets(3));

      // Continue button
      expect(find.text('Continue'), findsOneWidget);

      // Login link
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Login Here'), findsOneWidget);
    });

    testWidgets('renders fully localized in Swahili', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CreateAccountScreen(),
          locale: const Locale('sw'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unda Akaunti Yako'), findsOneWidget);
      expect(find.text('Endelea'), findsOneWidget);
      expect(find.text('Tayari una akaunti?'), findsOneWidget);
      expect(find.text('Ingia Hapa'), findsOneWidget);
    });
  });

  group('CreateAccountOtpScreen Tests', () {
    testWidgets('renders phone number, OTP input, and Verify button in English',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CreateAccountOtpScreen(phoneNumber: '+255 712 345 678'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Title & Subtitle containing Phone
      expect(find.text('Phone Verification'), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) =>
            w is RichText && w.text.toPlainText().contains('+255 712 345 678')),
        findsOneWidget,
      );

      // Custom OTP input
      expect(find.byType(CustomOtpInput), findsOneWidget);

      // Verify and continue button
      expect(find.text('Verify & Continue'), findsOneWidget);
    });

    testWidgets('renders fully localized in Swahili', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CreateAccountOtpScreen(phoneNumber: '+255 712 345 678'),
          locale: const Locale('sw'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Uhakiki wa Namba ya Simu'), findsOneWidget);
      expect(find.text('Hakiki na Uendelee'), findsOneWidget);
    });
  });

  group('NidaInfoConfirmationScreen Tests', () {
    final sampleData = ProfileRegistrationData()
      ..firstName = 'Baraka'
      ..middleName = 'Juma'
      ..lastName = 'Mushi'
      ..gender = 'Male'
      ..dob = DateTime(1995, 8, 20)
      ..city = 'Dar es Salaam'
      ..country = 'Tanzania'
      ..nin = '19950820123450000189'
      ..phone = '712345678'
      ..isNidaVerified = true;

    testWidgets('renders clean profile image box, information rows, and action buttons in English',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          NidaInfoConfirmationScreen(profileData: sampleData),
        ),
      );
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('NIDA Information Confirmation'), findsOneWidget);
      expect(find.text('Your Information'), findsOneWidget);

      // Profile avatar image box is rendered without verified badges
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Verified by NIDA'), findsNothing);
      expect(find.text('Verified'), findsNothing);

      // Personal Details preview
      expect(find.text('BARAKA'), findsOneWidget);
      expect(find.text('JUMA'), findsOneWidget);
      expect(find.text('MUSHI'), findsOneWidget);
      expect(find.text('MALE'), findsOneWidget);
      expect(find.text('20/08/1995'), findsOneWidget);
      expect(find.text('DAR ES SALAAM'), findsOneWidget);

      // Buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Proceed'), findsOneWidget);
    });

    testWidgets('renders fully localized in Swahili without verified badges',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          NidaInfoConfirmationScreen(profileData: sampleData),
          locale: const Locale('sw'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Uhakiki wa Taarifa za NIDA'), findsOneWidget);
      expect(find.text('Taarifa Zako'), findsOneWidget);
      expect(find.text('Imethibitishwa na NIDA'), findsNothing);
      expect(find.text('Imethibitishwa'), findsNothing);
      expect(find.text('MWANAUME'), findsOneWidget);
      expect(find.text('Ghairi'), findsOneWidget);
      expect(find.text('Endelea'), findsOneWidget);
    });

    testWidgets('tapping Proceed navigates to RegistrationSuccessScreen',
        (WidgetTester tester) async {
      bool onConfirmedCalled = false;
      await tester.pumpWidget(
        buildTestableWidget(
          NidaInfoConfirmationScreen(
            profileData: sampleData,
            onConfirmed: () {
              onConfirmedCalled = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Proceed'));
      await tester.pumpAndSettle();

      expect(onConfirmedCalled, true);
    });
  });
}
