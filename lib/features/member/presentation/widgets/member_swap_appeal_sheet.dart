import 'package:flutter/material.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'member_replacement_appeal_sheet.dart';

export 'member_replacement_appeal_sheet.dart';

/// Legacy alias for [MemberReplacementAppealSheet].
/// As Kijumbe is the controller who is responsible for swapping turns,
/// the Member requests a Replacement Appeal to the leader.
class MemberSwapAppealSheet extends StatelessWidget {
  final GroupData group;
  final List<MemberData>? members;
  final MemberData currentMember;

  const MemberSwapAppealSheet({
    super.key,
    required this.group,
    this.members,
    required this.currentMember,
  });

  static Future<bool?> show(
    BuildContext context, {
    required GroupData group,
    required List<MemberData> members,
    required MemberData currentMember,
  }) {
    return MemberReplacementAppealSheet.show(
      context,
      group: group,
      currentMember: currentMember,
      members: members,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MemberReplacementAppealSheet(
      group: group,
      currentMember: currentMember,
    );
  }
}
