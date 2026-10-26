import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class MemberJoinGroupButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;

  const MemberJoinGroupButton({
    super.key,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final effectivePrimary = AppColors.primaryFor(isDark);

    return GestureDetector(
      onTap: onTap ?? () => MemberJoinGroupSheet.show(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: effectivePrimary.withValues(alpha: isDark ? 0.16 : 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: effectivePrimary.withValues(alpha: isDark ? 0.45 : 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vpn_key_outlined,
              color: effectivePrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n?.enterGroupCode ?? 'Join a Group (Enter Code)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: effectivePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
