import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';

void main() {
  testWidgets('KijumbeGroupDetailScreen renders clean top bar and details card',
      (WidgetTester tester) async {
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

    await tester.pumpWidget(
      const MaterialApp(
        home: KijumbeGroupDetailScreen(group: testGroup),
      ),
    );

    // 1. Verify Top Bar title
    expect(find.text('Group Details'), findsOneWidget);

    // 2. Verify Group Header Card contents
    expect(find.text('Family Welfare Circle'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Target Pool'), findsOneWidget);
    expect(find.text('TZS 600,000'), findsWidgets);
    expect(find.text('Round 3'), findsWidgets);

    // 3. Verify options button opens bottom sheet
    await tester.tap(find.byIcon(Icons.more_vert_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Share Group Link'), findsOneWidget);
    expect(find.text('Group Rules & Terms'), findsOneWidget);
  });
}
