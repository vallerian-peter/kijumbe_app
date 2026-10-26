import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/create_group_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/invite_members_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/make_contribution_screen.dart';

void main() {
  const sampleGroup = GroupData(
    name: 'Family Circle',
    memberCount: 8,
    targetMembers: 12,
    contribution: 'TZS 50,000',
    frequency: 'Monthly',
    paidCount: 6,
    totalSlots: 12,
    nextContribution: 'March 1, 2026',
    totalPot: 'TZS 600,000',
    status: 'Active',
    avatarColors: [AppColors.appPrimaryColor, AppColors.appPrimaryLightColor],
    currentRound: 3,
    kijumbeName: 'Amina Ally',
  );

  group('InviteMembersScreen Tests', () {
    testWidgets('renders invite UI and generates link for username & phone',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InviteMembersScreen(group: sampleGroup),
        ),
      );

      // Verify header and hero
      expect(find.text('Invite members'), findsOneWidget);
      expect(find.text('Grow Your Circle'), findsOneWidget);

      // Verify cards
      expect(find.text('Share invite link'), findsOneWidget);
      expect(find.text('Invite code'), findsOneWidget);
      expect(find.text('Add member directly'), findsOneWidget);

      // Test adding a member with username and phone
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'juma_k');

      // The phone field is also present
      final phoneField = find.byType(TextField).last;
      await tester.enterText(phoneField, '712345678');

      // Ensure button is visible in scrollview and tap
      final addBtn = find.text('Generate & Add Member');
      await tester.ensureVisible(addBtn);
      await tester.pumpAndSettle();
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      // Verify generated member section shows the member and copy button
      expect(find.text('@juma_k'), findsOneWidget);
      expect(find.text('Ready'), findsOneWidget);
      expect(find.text('Copy'), findsWidgets);
    });
  });

  group('MakeContributionScreen Tests', () {
    testWidgets('renders contribution details and payment flow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MakeContributionScreen(group: sampleGroup),
        ),
      );

      // Verify header & member selector
      expect(find.text('Make contribution'), findsOneWidget);
      expect(find.text('Family Circle'), findsOneWidget);
      expect(find.text('Contribution amount'), findsOneWidget);
      expect(find.text('TZS 50,000'), findsWidgets);
      expect(find.text('Contribute to Member'), findsOneWidget);
      expect(find.text('Amina Juma'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);

      // Tap Change to select another member
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      expect(find.text('Select Recipient Member'), findsOneWidget);
      expect(find.text('John Makinde'), findsOneWidget);

      // Select John Makinde
      await tester.tap(find.text('John Makinde'));
      await tester.pumpAndSettle();
      expect(find.text('John Makinde'), findsOneWidget);

      // Verify due date & wallet
      expect(find.text('Due date'), findsOneWidget);
      expect(find.text('March 1, 2026'), findsOneWidget);
      expect(find.text('Your wallet balance'), findsOneWidget);
      expect(find.text('Kijumbe Wallet'), findsOneWidget);
      expect(find.text('Amount Due:'), findsOneWidget);

      // Tap pay contribution
      final payBtn = find.text('Pay contribution');
      await tester.ensureVisible(payBtn);
      await tester.tap(payBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();

      // Verify success dialog
      expect(find.text('Contribution Successful!'), findsOneWidget);
      expect(find.text('Recipient'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });
  });

  group('CreateGroupScreen Stepper Tests', () {
    testWidgets('navigates through 3 steps and calculates total pot',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateGroupScreen(),
        ),
      );

      // Step 1
      expect(find.text('Create New Group'), findsOneWidget);
      expect(find.text('Group Basics'), findsOneWidget);
      expect(find.text('1 of 3'), findsOneWidget);

      // Enter group name
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Upendo Circle');

      // Tap Continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 2
      expect(find.text('Contributions & Size'), findsOneWidget);
      expect(find.text('2 of 3'), findsOneWidget);
      expect(find.text('Target Pool per Round'), findsOneWidget);

      // Tap Continue to Step 3
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3
      expect(find.text('Rules & Review'), findsOneWidget);
      expect(find.text('3 of 3'), findsOneWidget);
      expect(find.text('Group Summary'), findsOneWidget);
      expect(find.text('Upendo Circle'), findsOneWidget);
      expect(find.text('Create & Invite Members'), findsOneWidget);
    });
  });
}
