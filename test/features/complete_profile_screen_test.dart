import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';
import 'package:kijumbe_app/features/kijumbe/kijumbe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
    ThemeManager.init();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: child),
    );
  }

  test('DateValidationUtils correctly calculates age and 18+ requirement', () {
    final now = DateTime(2026, 9, 20);

    // Exactly 18 years old
    final dob18 = DateTime(2008, 9, 20);
    expect(DateValidationUtils.calculateAge(dob18, referenceDate: now), 18);
    expect(DateValidationUtils.is18OrOlder(dob18, referenceDate: now), true);

    // 17 years and 364 days old (underage)
    final dob17 = DateTime(2008, 9, 21);
    expect(DateValidationUtils.calculateAge(dob17, referenceDate: now), 17);
    expect(DateValidationUtils.is18OrOlder(dob17, referenceDate: now), false);

    // 25 years old
    final dob25 = DateTime(2001, 1, 15);
    expect(DateValidationUtils.calculateAge(dob25, referenceDate: now), 25);
    expect(DateValidationUtils.is18OrOlder(dob25, referenceDate: now), true);
  });

  test('ProfileRegistrationData validation works across all 6 stretched steps', () {
    final data = ProfileRegistrationData();
    expect(data.isStep1Valid, false);

    data.firstName = 'John';
    data.lastName = 'Doe';
    expect(data.isStep1Valid, true);

    expect(data.isStep2Valid, false);
    data.dob = DateTime(2000, 1, 1);
    expect(data.isStep2Valid, true);

    expect(data.isStep3Valid, false);
    data.streetAddress = 'Mikocheni';
    expect(data.isStep3Valid, true);

    expect(data.isStep4Valid, false);
    data.isNidaVerified = true;
    expect(data.isStep4Valid, true);

    expect(data.isStep5Valid, false);
    data.phone = '712345678';
    expect(data.isStep5Valid, true);

    expect(data.isStep6Valid, false);
    data.otpCode = '123456';
    expect(data.isStep6Valid, true);
  });

  testWidgets('CompleteProfileScreen renders Step 1 Legal Names with stepper',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(const CompleteProfileScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(HorizontalStepper), findsOneWidget);
    expect(find.text('Tell Us About Yourself'), findsOneWidget);
    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('NidaVerificationStep renders NIN input and notice card',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        NidaVerificationStep(
          initialNin: '',
          initialVerified: false,
          onNinChanged: (_) {},
          onVerificationStatusChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('NIDA Identity Verification'), findsOneWidget);
    expect(find.text('National Identification Number (NIN)'), findsOneWidget);
    expect(find.text('NIDA Security Verification'), findsOneWidget);
    expect(find.text('Verify with NIDA (Answer Question)'), findsOneWidget);
  });

  testWidgets('CompleteProfileScreen renders fully localized in Swahili',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sw'),
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(body: CompleteProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HorizontalStepper), findsOneWidget);
    expect(find.text('Tueleze Kukuhusu'), findsOneWidget);
    expect(find.text('Jina la kwanza'), findsOneWidget);
    expect(find.text('Jina la ukoo'), findsOneWidget);
    expect(find.text('Endelea'), findsOneWidget);
  });

  testWidgets('NidaVerificationStep renders fully localized in Swahili',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sw'),
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: NidaVerificationStep(
            initialNin: '',
            initialVerified: false,
            onNinChanged: (_) {},
            onVerificationStatusChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Uthibitisho wa Kitambulisho cha NIDA'), findsOneWidget);
    expect(find.text('Nambari ya Utambulisho wa Taifa (NIN)'), findsOneWidget);
    expect(find.text('Uhakiki wa Usalama wa NIDA'), findsOneWidget);
    expect(find.text('Hakiki na NIDA (Jibu Swali)'), findsOneWidget);
  });

  testWidgets('NidaVerificationStep renders verified card with Verify Again below NIN',
      (WidgetTester tester) async {
    bool verificationStatus = true;
    await tester.pumpWidget(
      createTestWidget(
        NidaVerificationStep(
          initialNin: '19911223445566778811',
          initialVerified: true,
          onNinChanged: (_) {},
          onVerificationStatusChanged: (status) {
            verificationStatus = status;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('NIDA Verified'), findsOneWidget);
    expect(find.text('NIN: 19911223-44556-67788-11'), findsOneWidget);
    expect(find.text('Verify Again'), findsOneWidget);

    // Verify tap re-verifies
    await tester.tap(find.text('Verify Again'));
    await tester.pumpAndSettle();
    expect(verificationStatus, false);
    expect(find.text('Verify with NIDA (Answer Question)'), findsOneWidget);
  });

  testWidgets('RegistrationSuccessScreen renders celebration falling particles and proceed button',
      (WidgetTester tester) async {
    bool proceeded = false;
    await tester.pumpWidget(
      createTestWidget(
        RegistrationSuccessScreen(
          firstName: 'Amani',
          phone: '+255 712 345 678',
          onProceed: () {
            proceeded = true;
          },
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Registration Successful!'), findsOneWidget);
    expect(find.textContaining('Welcome, Amani!'), findsOneWidget);
    // Verified credentials pill removed as requested
    expect(find.text('NIDA Verified'), findsNothing);
    expect(find.text('+255 712 345 678'), findsNothing);
    expect(find.text('Proceed'), findsOneWidget);

    await tester.tap(find.text('Proceed'));
    await tester.pump();
    expect(proceeded, true);
  });

  testWidgets('RegistrationSuccessScreen renders fully localized in Swahili without verified pill',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sw'),
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(
          body: RegistrationSuccessScreen(
            firstName: 'Baraka',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Usajili Umekamilika!'), findsOneWidget);
    expect(find.text('Endelea'), findsOneWidget);
    // Imethibitishwa na NIDA pill removed
    expect(find.text('Imethibitishwa na NIDA'), findsNothing);
  });

  testWidgets('ConfirmationAlertDialog with showCancel: false renders only single continue button',
      (WidgetTester tester) async {
    bool confirmed = false;
    await tester.pumpWidget(
      createTestWidget(
        ConfirmationAlertDialog(
          type: AlertType.success,
          title: 'Wasifu Umekamilika!',
          message: 'Utambulisho wako na namba ya simu vimethibitishwa kikamilifu.',
          confirmText: 'Endelea',
          showCancel: false,
          onConfirm: () {
            confirmed = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wasifu Umekamilika!'), findsOneWidget);
    expect(find.text('Endelea'), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);

    await tester.tap(find.text('Endelea'));
    await tester.pumpAndSettle();
    expect(confirmed, true);
  });

  testWidgets('CustomActionDialog renders with 2 buttons, title, subtitle and content',
      (WidgetTester tester) async {
    bool primaryTapped = false;
    bool secondaryTapped = false;

    await tester.pumpWidget(
      createTestWidget(
        CustomActionDialog(
          title: 'Edit Full Name',
          subtitle: 'Update your name as per NIDA',
          content: const Text('Field content here'),
          primaryButtonText: 'Update',
          secondaryButtonText: 'Cancel',
          onPrimaryPressed: () => primaryTapped = true,
          onSecondaryPressed: () => secondaryTapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit Full Name'), findsOneWidget);
    expect(find.text('Update your name as per NIDA'), findsOneWidget);
    expect(find.text('Field content here'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Update'));
    expect(primaryTapped, true);

    await tester.tap(find.text('Cancel'));
    expect(secondaryTapped, true);
  });

  testWidgets('CustomActionDialog renders with single button when secondaryButtonText is null',
      (WidgetTester tester) async {
    bool primaryTapped = false;

    await tester.pumpWidget(
      createTestWidget(
        CustomActionDialog(
          title: 'Notice',
          subtitle: 'This is an informative notice.',
          primaryButtonText: 'Got It',
          onPrimaryPressed: () => primaryTapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notice'), findsOneWidget);
    expect(find.text('This is an informative notice.'), findsOneWidget);
    expect(find.text('Got It'), findsOneWidget);
    // Secondary button does not exist
    expect(find.text('Cancel'), findsNothing);

    await tester.tap(find.text('Got It'));
    expect(primaryTapped, true);
  });

  testWidgets('Endelea/Proceed button on RegistrationSuccessScreen navigates directly to KijumbeDashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('sw'),
        supportedLocales: AppLocales.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const RegistrationSuccessScreen(
          firstName: 'Juma',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Usajili Umekamilika!'), findsOneWidget);
    expect(find.text('Endelea'), findsOneWidget);

    await tester.tap(find.text('Endelea'));
    await tester.pumpAndSettle();

    expect(find.byType(KijumbeDashboard), findsOneWidget);
    expect(find.text('Kijumbe Dashboard'), findsOneWidget);
  });
}
