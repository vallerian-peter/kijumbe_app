import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'member_full_screen_loading.dart';

/// Bottom sheet allowing a Member to enter a group code and join
class MemberJoinGroupSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onGroupJoined;

  const MemberJoinGroupSheet({
    super.key,
    this.onGroupJoined,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    ValueChanged<Map<String, dynamic>>? onGroupJoined,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberJoinGroupSheet(onGroupJoined: onGroupJoined),
    );
  }

  @override
  State<MemberJoinGroupSheet> createState() => _MemberJoinGroupSheetState();
}

class _MemberJoinGroupSheetState extends State<MemberJoinGroupSheet> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      CustomToast.showWarning(context, context.l10n.enterGroupCodeHint);
      return;
    }

    final l10n = context.l10n;
    final nav = Navigator.of(context);

    // Close bottom sheet first
    nav.pop();

    // Trigger full screen loading with description
    final newGroup = await MemberFullScreenLoading.show<Map<String, dynamic>>(
      context,
      title: l10n.joiningGroupTitle,
      description: l10n.joiningGroupDesc,
      asyncTask: () async {
        await Future.delayed(const Duration(milliseconds: 1600));

        final groupName = code.contains('VIKOBA')
            ? 'Vikoba cha Maendeleo'
            : (code.contains('KJB') ? 'Kijumbe Tuinuke Group' : 'Akiba Yetu Savings');

        return <String, dynamic>{
          'id': 'group_${DateTime.now().millisecondsSinceEpoch}',
          'name': groupName,
          'code': code,
          'target': 5000000,
          'monthlyContribution': 50000,
          'membersCount': 10,
          'myTurn': 4,
          'totalTurns': 10,
          'nextPayoutDate': '15/10/2026',
          'cycleStatus': 'Active',
          'leaderName': 'Amina Rashid',
          'leaderPhone': '+255 754 123 456',
        };
      },
    );

    if (newGroup != null && mounted) {
      widget.onGroupJoined?.call(newGroup);
      CustomToast.showSuccess(context, l10n.groupJoinedSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag Handle
              Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon Pill
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: AppColors.greenColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                l10n.enterGroupCode,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: isDark ? Colors.white : AppColors.blackColor,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                l10n.memberRegistrationDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 24),

              // Code Input Field
              CustomTextField(
                controller: _codeController,
                hintText: l10n.enterGroupCodeHint,
                prefixIcon: const Icon(Icons.vpn_key_outlined, size: 20),
              ),
              const SizedBox(height: 14),

              // Quick chip examples
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${l10n.examples} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  _buildQuickCodeChip('KJB-8492', isDark),
                  const SizedBox(width: 8),
                  _buildQuickCodeChip('VIKOBA-2026', isDark),
                ],
              ),
              const SizedBox(height: 24),

              // Join Group Action Button
              CustomButon(
                text: l10n.joinGroupBtn,
                height: 52,
                borderRadius: 26,
                onPressed: _handleJoin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCodeChip(String code, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _codeController.text = code;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey[300]!,
            width: 0.8,
          ),
        ),
        child: Text(
          code,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.grey[700],
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
