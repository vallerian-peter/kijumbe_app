import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Personalized Summary Stats for Kikoba Member.
/// Focuses purely on the member's financial involvement:
/// 1. Active Groups joined
/// 2. My Contributions (paid cycles)
/// 3. My Payout Turn (zamu ya malipo)
/// Note: Does NOT show group management or total member status.
class MemberSummaryStats extends StatelessWidget {
  final int activeGroups;
  final int paidContributions;
  final int totalTargetContributions;
  final int myTurn;
  final bool isDark;

  const MemberSummaryStats({
    super.key,
    required this.activeGroups,
    required this.paidContributions,
    this.totalTargetContributions = 12,
    required this.myTurn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkGreyColor : Colors.white;
    final isSw = Localizations.localeOf(context).languageCode == 'sw';

    final stats = [
      DashboardStatItem(
        label: l10n?.activeGroups ?? 'Active\nGroups',
        value: '$activeGroups',
        icon: Iconsax.people_outline,
        iconColor: isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor,
      ),
      DashboardStatItem(
        label: isSw ? 'Michango\nYangu' : 'My\nContributions',
        value: '$paidContributions/$totalTargetContributions',
        icon: Icons.check_circle_outline_rounded,
        iconColor: const Color(0xFF00C9A7),
      ),
      DashboardStatItem(
        label: isSw ? 'Zamu\nYangu' : 'My Payout\nTurn',
        value: l10n?.turnNumber(myTurn) ?? 'Turn #$myTurn',
        icon: Icons.hourglass_top_rounded,
        iconColor: const Color(0xFFFF9671),
      ),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: stats.asMap().entries.map((e) {
          final stat = e.value;
          final isLast = e.key == stats.length - 1;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: isLast ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: stat.iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(stat.icon, color: stat.iconColor, size: 16),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stat.value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        stat.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                          color: isDark
                              ? Colors.white54
                              : AppColors.darkGreyColor.withValues(alpha: 0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
