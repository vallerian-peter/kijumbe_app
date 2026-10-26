import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupProgressCard extends StatelessWidget {
  final GroupData group;
  final double progress;
  final bool isDark;

  const GroupProgressCard({
    super.key,
    required this.group,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;
    final effectivePrimary =
        isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor;
    final pct = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.contributionProgress ?? 'Contribution Progress',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.blackColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: effectivePrimary.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: effectivePrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFFEEF2F6),
              valueColor: AlwaysStoppedAnimation<Color>(effectivePrimary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${group.paidCount} of ${group.totalSlots} ${l10n?.slotsPaid ?? 'slots paid'}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF7A8A9E),
                ),
              ),
              Text(
                '${group.totalSlots - group.paidCount} ${l10n?.remaining ?? 'remaining'}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9671),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
