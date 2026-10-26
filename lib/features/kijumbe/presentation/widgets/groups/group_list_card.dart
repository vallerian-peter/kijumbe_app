import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_card.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/make_contribution_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupListCard extends StatelessWidget {
  final GroupsListItem group;
  final bool isDark;
  final VoidCallback? onTap;

  const GroupListCard({
    super.key,
    required this.group,
    required this.isDark,
    this.onTap,
  });

  GroupData _toGroupData() {
    return GroupData(
      name: group.name,
      memberCount: group.memberCount,
      targetMembers: group.targetMembers,
      contribution: group.contribution,
      frequency: group.frequency,
      paidCount: group.paidCount,
      totalSlots: group.totalSlots,
      nextContribution: group.nextContribution,
      totalPot: group.totalPot,
      status: group.status == GroupItemStatus.active ? 'Active' : 'Pending',
      avatarColors: group.avatarColors,
      currentRound: group.currentRound,
      kijumbeName: group.kijumbeName,
    );
  }

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
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;
    final effectivePrimary =
        isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor;
    final progress =
        group.totalSlots > 0 ? group.paidCount / group.totalSlots : 0.0;
    final groupAvatarColor =
        _resolveAvatarColor(group.avatarColors[0], isDark);

    return CustomCard(
      bgColor: cardBg,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      onTap: onTap ??
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KijumbeGroupDetailScreen(
                    group: _toGroupData(),
                  ),
                ),
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row ────────────────────────────────────────────────────────
          Row(
            children: [
              // Group avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: groupAvatarColor.withValues(alpha: isDark ? 0.22 : 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: groupAvatarColor.withValues(alpha: 0.45),
                      width: 1.5),
                ),
                child: Center(
                  child: Text(
                    group.name[0].toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: groupAvatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${group.memberCount}/${group.targetMembers} ${l10n?.members ?? 'members'} • ${group.contribution}/${localizeFrequency(group.frequency, l10n)}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: group.status == GroupItemStatus.active
                      ? effectivePrimary.withValues(alpha: isDark ? 0.18 : 0.1)
                      : AppColors.yellowColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  group.status == GroupItemStatus.active
                      ? (l10n?.activeTab ?? 'Active')
                      : (l10n?.pendingTab ?? 'Pending'),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: group.status == GroupItemStatus.active
                        ? effectivePrimary
                        : const Color(0xFFD4A017),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Progress ────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.membersPaid ?? 'Member paid',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              Text(
                '${group.paidCount} of ${group.totalSlots}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : AppColors.darkGreyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: effectivePrimary.withValues(alpha: isDark ? 0.2 : 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(effectivePrimary),
            ),
          ),

          const SizedBox(height: 12),

          // ── Bottom row ──────────────────────────────────────────────────────
          Row(
            children: [
              _buildStackedAvatars(group.avatarColors),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 11,
                      color: isDark ? Colors.white54 : Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n?.nextPayout ?? 'Next'}: ${group.nextContribution}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MakeContributionScreen(
                        group: _toGroupData(),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryButtonGradientFor(isDark),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: effectivePrimary.withValues(alpha: isDark ? 0.35 : 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n?.contribute ?? 'Contribute',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(List<Color> colors) {
    const double avatarSize = 22.0;
    const double overlap = 14.0;
    return SizedBox(
      height: avatarSize,
      width: (colors.length * overlap) + (avatarSize - overlap),
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
                  color: isDark ? const Color(0xFF3D3D3D) : Colors.white,
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

