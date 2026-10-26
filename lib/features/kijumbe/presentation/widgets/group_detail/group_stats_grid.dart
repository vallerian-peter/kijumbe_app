import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupStatsGrid extends StatelessWidget {
  final GroupData group;
  final bool isDark;

  const GroupStatsGrid({
    super.key,
    required this.group,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;

    final stats = [
      _StatItem(
        label: l10n?.contributionAmount ?? 'Contribution',
        value: group.contribution,
        icon: Iconsax.wallet_2_outline,
        color: AppColors.primaryColor,
      ),
      _StatItem(
        label: l10n?.frequency ?? 'Frequency',
        value: localizeFrequency(group.frequency, l10n),
        icon: Icons.schedule_rounded,
        color: const Color(0xFF845EC2),
      ),
      _StatItem(
        label: l10n?.membersPaid ?? 'Members Paid',
        value: '${group.paidCount} of ${group.totalSlots}',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.greenColor,
      ),
      _StatItem(
        label: l10n?.nextPayout ?? 'Next Payout',
        value: group.nextContribution,
        icon: Icons.calendar_today_outlined,
        color: const Color(0xFFFF9671),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatCard(stats[0], cardBg, isDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(stats[1], cardBg, isDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatCard(stats[2], cardBg, isDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(stats[3], cardBg, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(_StatItem stat, Color cardBg, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : const Color(0xFF7A8A9E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(stat.icon, color: stat.color, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.blackColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
