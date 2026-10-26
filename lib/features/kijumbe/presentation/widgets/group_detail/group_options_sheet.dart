import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/invite_members_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupOptionsSheet extends StatelessWidget {
  final GroupData group;
  final bool isDark;
  final VoidCallback onQuickInvite;
  final VoidCallback? onSwapTurns;

  const GroupOptionsSheet({
    super.key,
    required this.group,
    required this.isDark,
    required this.onQuickInvite,
    this.onSwapTurns,
  });

  static void show(
    BuildContext context, {
    required GroupData group,
    required bool isDark,
    required VoidCallback onQuickInvite,
    VoidCallback? onSwapTurns,
  }) {
    final sheetBg = isDark ? const Color(0xFF2E2E2E) : Colors.white;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => GroupOptionsSheet(
        group: group,
        isDark: isDark,
        onQuickInvite: () {
          Navigator.pop(ctx);
          onQuickInvite();
        },
        onSwapTurns: onSwapTurns != null
            ? () {
                Navigator.pop(ctx);
                onSwapTurns();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              title: Text(
                l10n?.shareGroupLink ?? 'Share Group Link',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.blackColor,
                ),
              ),
              subtitle: Text(
                'Invite others to join this Kijumbe circle',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InviteMembersScreen(group: group),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.greenColor,
                  size: 20,
                ),
              ),
              title: Text(
                l10n?.quickInviteByPhone ?? 'Quick Invite by Phone',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.blackColor,
                ),
              ),
              subtitle: Text(
                'Directly invite via phone number modal',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              onTap: onQuickInvite,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rule_folder_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: Text(
                l10n?.groupRulesAndTerms ?? 'Group Rules & Terms',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.blackColor,
                ),
              ),
              subtitle: Text(
                'View payout schedules and group terms',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            if (onSwapTurns != null) ...[
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.appPrimaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  l10n?.swapMemberTurns ?? 'Swap Member Turns',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                ),
                subtitle: Text(
                  l10n?.swapMemberTurnsSubtitle ??
                      'Reorder payout turns between two members',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
                onTap: onSwapTurns,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
