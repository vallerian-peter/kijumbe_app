import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class DashboardGroupCard extends StatelessWidget {
  final DashboardGroupSummary group;
  final bool isDark;
  final VoidCallback? onTap;

  const DashboardGroupCard({
    super.key,
    required this.group,
    required this.isDark,
    this.onTap,
  });

  Color _resolveAvatarColor(Color color, bool isDark) {
    if (isDark &&
        (color == AppColors.appPrimaryColor ||
            color == AppColors.blueSkyStrong ||
            color == AppColors.appPrimaryDarkColor)) {
      return AppColors.darkModePrimaryColor;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkGreyColor : Colors.white;
    final effectivePrimary =
        isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor;
    final progress =
        group.totalSlots > 0 ? group.paidCount / group.totalSlots : 0.0;
    final groupAvatarColor =
        _resolveAvatarColor(group.avatarColors[0], isDark);

    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => KijumbeGroupDetailScreen(
              group: GroupData(
                name: group.name,
                memberCount: group.memberCount,
                targetMembers: group.targetMembers,
                contribution: group.contributionAmount,
                frequency: group.frequency,
                paidCount: group.paidCount,
                totalSlots: group.totalSlots,
                nextContribution: group.nextPayout,
                totalPot: group.totalPot,
                status: 'Active',
                avatarColors: group.avatarColors,
                currentRound: 3,
                kijumbeName: 'You',
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group name row
            Row(
              children: [
                _buildGroupInitialAvatar(
                    groupAvatarColor, group.name[0]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${group.memberCount}/${group.targetMembers} ${l10n?.members.toLowerCase() ?? 'members'} • ${group.contributionAmount}/${localizeFrequency(group.frequency, l10n)}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildStackedAvatars(group.avatarColors),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n?.membersPaid ?? 'Member paid',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${group.paidCount} of ${group.totalSlots}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor:
                    effectivePrimary.withValues(alpha: isDark ? 0.2 : 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(effectivePrimary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 10,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${l10n?.nextPayout ?? 'Next'}: ${group.nextPayout}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  group.totalPot,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: effectivePrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInitialAvatar(Color color, String initial) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.22 : 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.2),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildStackedAvatars(List<Color> colors) {
    const double avatarSize = 22.0;
    const double overlap = 14.0;
    return SizedBox(
      height: avatarSize,
      width: double.infinity,
      child: Stack(
        children: colors.asMap().entries.map((entry) {
          final index = entry.key;
          final color = _resolveAvatarColor(entry.value, isDark);
          return Positioned(
            left: index * overlap,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkGreyColor : Colors.white,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

