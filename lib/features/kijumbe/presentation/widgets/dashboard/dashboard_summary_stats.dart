import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class DashboardSummaryStats extends StatelessWidget {
  final int activeGroups;
  final int totalMembers;
  final int currentRound;
  final bool isDark;

  const DashboardSummaryStats({
    super.key,
    required this.activeGroups,
    required this.totalMembers,
    required this.currentRound,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkGreyColor : Colors.white;

    final stats = [
      DashboardStatItem(
        label: l10n?.activeGroups ?? 'Active\nGroups',
        value: '$activeGroups',
        icon: Iconsax.people_outline,
        iconColor: isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor,
      ),
      DashboardStatItem(
        label: l10n?.members ?? 'Total\nMembers',
        value: '$totalMembers',
        icon: Bootstrap.person_check,
        iconColor: const Color(0xFF845EC2),
      ),
      DashboardStatItem(
        label: l10n?.currentRound ?? 'Current\nRound',
        value: 'R$currentRound',
        icon: Icons.refresh_rounded,
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
                          fontSize: 16,
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
