import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/features/onboarding/presentation/widgets/registration_type_bottom_sheet.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/kijumbe_swap_turns_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppStorageManager.init();
    LocaleManager.init();
  });

  Widget buildTestableWidget(Widget child,
      {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocales.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('RegistrationTypeBottomSheet Tests', () {
    testWidgets('renders 2 registration cards (Kijumbe and Member)',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildTestableWidget(const RegistrationTypeBottomSheet()));
      await tester.pumpAndSettle();

      expect(find.text('Select Account Type'), findsOneWidget);
      expect(find.text('Kijumbe (Leader)'), findsOneWidget);
      expect(find.text('Member'), findsOneWidget);
    });

    testWidgets('renders localized in Swahili', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const RegistrationTypeBottomSheet(),
          locale: const Locale('sw'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chagua Aina ya Akaunti'), findsOneWidget);
      expect(find.text('Kijumbe (Kiongozi)'), findsOneWidget);
      expect(find.text('Mwanachama'), findsOneWidget);
    });
  });

  group('MemberCreateAccountScreen Tests', () {
    testWidgets('renders phone, password, and continue button',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildTestableWidget(const MemberCreateAccountScreen()));
      await tester.pumpAndSettle();

      expect(find.text('MEMBER'), findsNothing);
      expect(find.text('Create Your Account'), findsOneWidget);
      expect(find.byType(CustomPhoneNumberField), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });

  group('MemberCompleteProfileScreen Tests', () {
    testWidgets('renders stepper Step 1 (names) and transitions to Step 2 (dob, gender)',
        (WidgetTester tester) async {
      final profile = MemberProfileData(
        phone: '+255712345678',
        password: 'Password123!',
      );
      await tester.pumpWidget(
        buildTestableWidget(MemberCompleteProfileScreen(profileData: profile)),
      );
      await tester.pumpAndSettle();

      // HorizontalStepper present
      expect(find.byType(HorizontalStepper), findsOneWidget);

      // Verify AppBar title and removal of redundant section title
      expect(find.text('Tell Us About Yourself'), findsNothing);
      expect(find.text('Complete your profile'), findsOneWidget);

      // Step 1: Names
      expect(find.text('First name'), findsOneWidget);
      expect(find.text('Last name'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // NIDA should NEVER be present on Member Complete Profile
      expect(find.text('NIDA Number'), findsNothing);
      expect(find.text('Nin'), findsNothing);

      // Enter names and continue to Step 2
      await tester.enterText(find.byType(TextFormField).first, 'Jane');
      await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 2: DOB & Gender
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Complete Profile'), findsOneWidget);
    });

    testWidgets('renders MemberCompleteProfileScreen localized in Swahili',
        (WidgetTester tester) async {
      final profile = MemberProfileData(
        phone: '+255712345678',
        password: 'Password123!',
      );
      await tester.pumpWidget(
        buildTestableWidget(
          MemberCompleteProfileScreen(profileData: profile),
          locale: const Locale('sw'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HorizontalStepper), findsOneWidget);
      expect(find.text('Taarifa Binafsi'), findsOneWidget);
      expect(find.text('Jina la kwanza'), findsOneWidget);
      expect(find.text('Jina la ukoo'), findsOneWidget);
      expect(find.text('Endelea'), findsOneWidget);
    });

    testWidgets('tapping Proceed on RegistrationSuccessScreen navigates directly to MemberHomeScreen',
        (WidgetTester tester) async {
      final profile = MemberProfileData(
        phone: '+255712345678',
        password: 'Password123!',
      );
      await tester.pumpWidget(
        buildTestableWidget(MemberCompleteProfileScreen(profileData: profile)),
      );
      await tester.pumpAndSettle();

      // Step 1: Fill names
      await tester.enterText(find.byType(TextFormField).first, 'Jane');
      await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 2: Set DOB & Gender
      profile.dob = DateTime(1995, 5, 15);
      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();

      // Submit profile
      await tester.tap(find.text('Complete Profile'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify on RegistrationSuccessScreen
      expect(find.byType(RegistrationSuccessScreen), findsOneWidget);
      expect(find.text('Proceed'), findsOneWidget);

      // Tap Proceed - MUST navigate to MemberHomeScreen without State.context unmounted error!
      await tester.tap(find.text('Proceed'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MemberHomeScreen), findsOneWidget);
      expect(find.text('Dashboard'), findsWidgets);
    });
  });

  group('MemberHomeScreen and Tabs Tests', () {
    testWidgets('renders Dashboard, My Groups, and Settings tabs matching Kijumbe layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const MemberHomeScreen()));
      await tester.pumpAndSettle();

      // Bottom nav labels
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Groups'), findsWidgets);
      expect(find.text('Settings'), findsWidgets);

      // Default tab: Dashboard
      expect(find.byType(MemberDashboardScreen), findsOneWidget);
      expect(find.text('Active Groups'), findsWidgets);
      expect(find.text('Enter Group Code'), findsOneWidget);
      expect(find.text('Recent Activity'), findsWidgets);
      expect(find.text('Contribute'), findsOneWidget);
      expect(find.text('Replacement Appeal'), findsOneWidget);
      expect(find.text('Swap Turn'), findsNothing);
      expect(find.text('My Total Savings'), findsOneWidget);

      // Verify absence of leader-only / non-member actions and labels:
      expect(find.text('Cash Out'), findsNothing);
      expect(find.text('Request'), findsNothing);
      expect(find.text('Send'), findsNothing);
      expect(find.text('Total Members'), findsNothing);
      expect(find.text('Total Pool Balance'), findsNothing);

      // Tap Groups tab
      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();

      expect(find.byType(MemberGroupsScreen), findsOneWidget);
      expect(find.text('My Groups'), findsOneWidget);
      expect(find.text('Join Group'), findsOneWidget);

      // Tap Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.byType(MemberSettingsScreen), findsOneWidget);
      // Title MUST be Settings, not Preferences
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Preferences'), findsOneWidget); // Section header
      expect(find.text('Salma Rashid'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('tapping Settings profile card navigates to MemberProfileScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const MemberHomeScreen()));
      await tester.pumpAndSettle();

      // Go to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Tap profile card
      await tester.tap(find.text('Salma Rashid'));
      await tester.pumpAndSettle();

      // Should be on MemberProfileScreen
      expect(find.byType(MemberProfileScreen), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Salma Rashid'), findsWidgets);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      // MemberProfileScreen MUST NOT have NIDA
      expect(find.text('NIDA Number'), findsNothing);
    });
  });

  group('MemberGroupDetailScreen Tests', () {
    testWidgets('renders group details and exactly 2 actions (Swap Appeal and Contribute)',
        (WidgetTester tester) async {
      const sampleGroup = GroupData(
        name: 'Upendo Savings Group',
        memberCount: 5,
        targetMembers: 6,
        contribution: 'TZS 50,000',
        frequency: 'Monthly',
        paidCount: 4,
        totalSlots: 6,
        nextContribution: '15 Oct, 2024',
        totalPot: 'TZS 300,000',
        status: 'Active',
        avatarColors: [
          Color(0xFF00B4D8),
          Color(0xFF48CAE4),
        ],
        currentRound: 3,
        kijumbeName: 'Vallerian Mchau',
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const MemberGroupDetailScreen(group: sampleGroup),
        ),
      );
      await tester.pumpAndSettle();

      // Check Group title and status
      expect(find.text('Group Details'), findsOneWidget);
      expect(find.text('Upendo Savings Group'), findsOneWidget);

      // Check Member only 2 actions (Replacement Appeal and Contribute)
      expect(find.text('Replacement Appeal'), findsOneWidget);
      expect(find.text('Contribute'), findsOneWidget);

      // Check leader controls (Add Member, Group Rules & Terms, Remind) are absent from member view
      expect(find.text('Add Member'), findsNothing);
      expect(find.text('Quick Invite by Phone'), findsNothing);
    });
  });

  group('MemberJoinGroupSheet Tests', () {
    testWidgets('renders code input without paste button and displays Examples chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const MemberJoinGroupSheet(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify code input exists
      expect(find.byType(CustomTextField), findsOneWidget);

      // Verify Paste Button is removed
      expect(find.text('Paste Code'), findsNothing);
      expect(find.byIcon(Icons.content_paste_rounded), findsNothing);

      // Verify "Examples: " label and quick chips exist
      expect(find.text('Examples: '), findsOneWidget);
      expect(find.text('KJB-8492'), findsOneWidget);
      expect(find.text('VIKOBA-2026'), findsOneWidget);

      // Tapping an example chip fills in the code
      await tester.tap(find.text('KJB-8492'));
      await tester.pump();

      expect(find.text('KJB-8492'), findsNWidgets(2)); // in chip and in text field
    });
  });

  group('MemberReplacementAppealSheet Tests', () {
    testWidgets('renders Replacement Appeal sheet with leader name and turn info',
        (WidgetTester tester) async {
      const sampleGroup = GroupData(
        name: 'Upendo Savings Group',
        memberCount: 5,
        targetMembers: 6,
        contribution: 'TZS 50,000',
        frequency: 'Monthly',
        paidCount: 4,
        totalSlots: 6,
        nextContribution: '15 Oct, 2024',
        totalPot: 'TZS 300,000',
        status: 'Active',
        avatarColors: [Color(0xFF00B4D8)],
        currentRound: 3,
        kijumbeName: 'Vallerian Mchau',
      );

      const sampleMember = MemberData(
        name: 'Salma Rashid',
        phone: '+255 712 345 678',
        payoutOrder: 4,
        hasPaid: true,
        avatarColor: Color(0xFF00B4D8),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const MemberReplacementAppealSheet(
            group: sampleGroup,
            currentMember: sampleMember,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Replacement Appeal'), findsOneWidget);
      expect(find.text('Turn #4'), findsOneWidget);
      expect(find.textContaining('Vallerian Mchau'), findsWidgets);
      expect(find.text('Submit Appeal'), findsOneWidget);
    });
  });

  group('KijumbeSwapTurnsSheet Tests', () {
    testWidgets('renders swap member turns controller sheet for Kijumbe Leader',
        (WidgetTester tester) async {
      const sampleGroup = GroupData(
        name: 'Upendo Savings Group',
        memberCount: 2,
        targetMembers: 2,
        contribution: 'TZS 50,000',
        frequency: 'Monthly',
        paidCount: 2,
        totalSlots: 2,
        nextContribution: '15 Oct, 2024',
        totalPot: 'TZS 100,000',
        status: 'Active',
        avatarColors: [Color(0xFF00B4D8)],
        currentRound: 1,
        kijumbeName: 'Vallerian Mchau',
      );

      final members = [
        const MemberData(
          name: 'Vallerian Mchau',
          phone: '+255 712 345 678',
          payoutOrder: 1,
          hasPaid: true,
          avatarColor: Color(0xFF00B4D8),
        ),
        const MemberData(
          name: 'John Makinde',
          phone: '+255 754 123 456',
          payoutOrder: 2,
          hasPaid: true,
          avatarColor: Color(0xFF48CAE4),
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          KijumbeSwapTurnsSheet(
            group: sampleGroup,
            members: members,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Swap Member Turns'), findsOneWidget);
      expect(find.text('Select First Member'), findsOneWidget);
      expect(find.text('Select Second Member'), findsOneWidget);
      expect(find.text('Confirm & Swap Turns'), findsOneWidget);
    });
  });
}
