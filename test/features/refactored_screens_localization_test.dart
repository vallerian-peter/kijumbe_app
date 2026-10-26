import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_profile_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/tabs/kijumbe_dashboard_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/tabs/kijumbe_groups_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/tabs/kijumbe_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createLocalizedTestWidget(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocales.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: child,
  );
}

const testGroup = GroupData(
  name: 'Family Welfare Circle',
  memberCount: 8,
  targetMembers: 12,
  contribution: 'TZS 50,000',
  frequency: 'Monthly',
  paidCount: 6,
  totalSlots: 12,
  nextContribution: '15 Oct 2026',
  totalPot: 'TZS 600,000',
  status: 'Active',
  avatarColors: [Color(0xFF2E7D32), Color(0xFF81C784)],
  currentRound: 3,
  kijumbeName: 'Amina Ally',
);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'kijumbe_theme_mode': 'light'});
    final storage = await AppStorageManager.init();
    ThemeManager.init(storage: storage);
  });

  group('Refactored Dashboard Screen', () {
    testWidgets('renders properly with all extracted components in English', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const Scaffold(body: KijumbeDashboardScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Active Groups'), findsWidgets);
      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('Create new Group'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
      expect(find.text('Request'), findsOneWidget);
      expect(find.text('Contribute'), findsWidgets);
      expect(find.text('Cash Out'), findsOneWidget);
    });

    testWidgets('renders localized content in Swahili', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(
        const Scaffold(body: KijumbeDashboardScreen()),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Vikundi Vinavyoendelea'), findsWidgets);
      expect(find.text('Mwenendo wa Hivi Karibuni'), findsOneWidget);
      expect(find.text('Tengeneza Kikundi Kipya'), findsOneWidget);
      expect(find.text('Tuma'), findsOneWidget);
      expect(find.text('Omba'), findsOneWidget);
      expect(find.text('Changia'), findsWidgets);
      expect(find.text('Toa Pesa'), findsOneWidget);
    });
  });

  group('Refactored Groups Tab Screen', () {
    testWidgets('renders properly with summary chips and group cards in English', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const Scaffold(body: KijumbeGroupsScreen())));
      await tester.pumpAndSettle();

      expect(find.text('My Groups'), findsOneWidget);
      expect(find.text('Create new Group'), findsOneWidget);
      expect(find.text('Contribute'), findsWidgets);
    });

    testWidgets('renders localized content in Swahili with Changia button', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(
        const Scaffold(body: KijumbeGroupsScreen()),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Vikundi Vyangu'), findsOneWidget);
      expect(find.text('Tengeneza Kikundi Kipya'), findsOneWidget);
      expect(find.text('Changia'), findsWidgets);
    });
  });

  group('Refactored Settings Tab Screen', () {
    testWidgets('renders profile card and settings groups in English', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const Scaffold(body: KijumbeSettingsScreen())));
      await tester.pumpAndSettle();

      expect(find.text('Vallerian Mchau'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('renders localized content in Swahili', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(
        const Scaffold(body: KijumbeSettingsScreen()),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Vallerian Mchau'), findsOneWidget);
      expect(find.text('Mapendeleo'), findsOneWidget);
      expect(find.text('Mandhari Meusi'), findsOneWidget);
    });
  });

  group('Refactored Profile Screen', () {
    testWidgets('renders hero header and information cards in English', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Vallerian Mchau'), findsWidgets);
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Identification'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Gender'), findsOneWidget);
    });

    testWidgets('renders localized content in Swahili', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(
        const KijumbeProfileScreen(),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Vallerian Mchau'), findsWidgets);
      expect(find.text('Taarifa Binafsi'), findsOneWidget);
      expect(find.text('Mahali'), findsOneWidget);
      expect(find.text('Utambulisho'), findsOneWidget);
      expect(find.text('Jina Kamili'), findsOneWidget);
      expect(find.text('Jinsia'), findsOneWidget);
    });

    testWidgets('tapping trailing pen shows edit dialog and updates field value', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeProfileScreen()));
      await tester.pumpAndSettle();

      // Find edit pen buttons (Iconsax.edit_2_outline)
      final penIcons = find.byIcon(Iconsax.edit_2_outline);
      expect(penIcons, findsWidgets);

      // Tap first edit pen (Full Name)
      await tester.tap(penIcons.first);
      await tester.pumpAndSettle();

      // Verify dialog is shown with field title and current value
      expect(find.text('Edit Full Name'), findsOneWidget);
      expect(find.text('Vallerian Mchau'), findsWidgets);

      // Enter new name
      await tester.enterText(find.byType(TextField), 'Emmanuel Ngallah');
      await tester.pump();

      // Tap Update button
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // Dialog is dismissed and profile screen reflects new name
      expect(find.text('Edit Full Name'), findsNothing);
      expect(find.text('Emmanuel Ngallah'), findsWidgets);
    });

    testWidgets('tapping phone pen shows IntlPhone field dialog and updates value', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeProfileScreen()));
      await tester.pumpAndSettle();

      final penIcons = find.byIcon(Iconsax.edit_2_outline);
      // Second pen is phone
      await tester.tap(penIcons.at(1));
      await tester.pumpAndSettle();

      expect(find.text('Edit Phone Number'), findsOneWidget);
      expect(find.byType(CustomPhoneNumberField), findsOneWidget);

      await tester.enterText(find.byType(TextField), '712111222');
      await tester.pump();

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Phone Number'), findsNothing);
      expect(find.text('+255 712 111 222'), findsOneWidget);
    });

    testWidgets('tapping gender pen shows dropdown and updates value', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeProfileScreen()));
      await tester.pumpAndSettle();

      final penIcons = find.byIcon(Iconsax.edit_2_outline);
      // Third pen is gender
      await tester.tap(penIcons.at(2));
      await tester.pumpAndSettle();

      expect(find.text('Edit Gender'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Tap 'Female'
      await tester.tap(find.text('Female').last);
      await tester.pumpAndSettle();

      // Tap Update
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Gender'), findsNothing);
      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('tapping DOB pen opens showCustomDatePicker with current dob', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeProfileScreen()));
      await tester.pumpAndSettle();

      final penIcons = find.byIcon(Iconsax.edit_2_outline);
      // Fourth pen is DOB
      await tester.tap(penIcons.at(3));
      await tester.pumpAndSettle();

      // showCustomDatePicker opens bottom sheet with title 'Date of Birth'
      expect(find.text('Date of Birth'), findsWidgets);
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Bottom sheet is dismissed
      expect(find.text('Save'), findsNothing);
    });
  });

  group('Refactored Group Details Screen', () {
    testWidgets('renders header, stats, progress and members in English', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(const KijumbeGroupDetailScreen(group: testGroup)));
      await tester.pumpAndSettle();

      expect(find.text('Group Details'), findsOneWidget);
      expect(find.text('Target Pool'), findsOneWidget);
      expect(find.text('Contribution'), findsOneWidget);
      expect(find.text('Frequency'), findsOneWidget);
      expect(find.text('Contribution Progress'), findsOneWidget);
      expect(find.text('Members'), findsWidgets);
    });

    testWidgets('renders localized content in Swahili', (tester) async {
      await tester.pumpWidget(createLocalizedTestWidget(
        const KijumbeGroupDetailScreen(group: testGroup),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Taarifa za Kikundi'), findsOneWidget);
      expect(find.text('Mfuko Lengo'), findsOneWidget);
      expect(find.text('Kiwango cha Mchango'), findsOneWidget);
      expect(find.text('Ratiba ya Malipo'), findsOneWidget);
      expect(find.text('Maendeleo ya Michango'), findsOneWidget);
      expect(find.text('Wanachama'), findsWidgets);
    });
  });

  group('CustomToast Localization', () {
    testWidgets('shows English titles for Success', (tester) async {
      late BuildContext testContext;
      await tester.pumpWidget(createLocalizedTestWidget(
        Builder(
          builder: (context) {
            testContext = context;
            return const SizedBox();
          },
        ),
      ));
      await tester.pumpAndSettle();

      CustomToast.showSuccess(testContext, 'Saved!');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Saved!'), findsOneWidget);

      CustomToast.dismiss();
      await tester.pumpAndSettle();
    });

    testWidgets('shows Swahili titles for Success, Warning, Error, Info', (tester) async {
      late BuildContext testContext;
      await tester.pumpWidget(createLocalizedTestWidget(
        Builder(
          builder: (context) {
            testContext = context;
            return const SizedBox();
          },
        ),
        locale: const Locale('sw'),
      ));
      await tester.pumpAndSettle();

      // Success
      CustomToast.showSuccess(testContext, 'Imekamilika!');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Imefanikiwa'), findsOneWidget);
      CustomToast.dismiss();
      await tester.pumpAndSettle();

      // Warning
      CustomToast.showWarning(testContext, 'Tahadhari ujumbe');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Tahadhari'), findsOneWidget);
      CustomToast.dismiss();
      await tester.pumpAndSettle();

      // Danger
      CustomToast.showDanger(testContext, 'Hitilafu ujumbe');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Hitilafu'), findsOneWidget);
      CustomToast.dismiss();
      await tester.pumpAndSettle();

      // Info
      CustomToast.showInfo(testContext, 'Taarifa ujumbe');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Taarifa'), findsOneWidget);
      CustomToast.dismiss();
      await tester.pumpAndSettle();
    });
  });
}
