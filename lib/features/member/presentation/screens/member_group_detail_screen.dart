import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_back_button.dart';
import 'package:kijumbe_app/core/components/custom_button.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/group_members_list_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_header_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_member_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_progress_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_stats_grid.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Screen displayed when a Member enters a joined group.
/// The member can observe the full group status, progress, and turns,
/// but can ONLY perform 2 actions:
/// 1. Make a contribution (`MemberContributionSheet`)
/// 2. Request a replacement appeal (`MemberReplacementAppealSheet`) to be replaced by the Kijumbe Leader
class MemberGroupDetailScreen extends StatefulWidget {
  final GroupData group;
  final MemberData currentMember;

  const MemberGroupDetailScreen({
    super.key,
    required this.group,
    this.currentMember = const MemberData(
      name: 'Salma Rashid',
      phone: '+255 712 345 678',
      payoutOrder: 4,
      hasPaid: false,
      avatarColor: Color(0xFF6C5CE7),
    ),
  });

  @override
  State<MemberGroupDetailScreen> createState() =>
      _MemberGroupDetailScreenState();
}

class _MemberGroupDetailScreenState extends State<MemberGroupDetailScreen> {
  late final List<MemberData> _members;
  late MemberData _currentMember;

  @override
  void initState() {
    super.initState();
    _currentMember = widget.currentMember;
    _members = [
      const MemberData(
        name: 'Vallerian Mchau',
        phone: '+255 712 345 678',
        payoutOrder: 1,
        hasPaid: true,
        avatarColor: Color(0xFF00B4D8),
        isKijumbe: true,
      ),
      const MemberData(
        name: 'John Makinde',
        phone: '+255 754 123 456',
        payoutOrder: 2,
        hasPaid: true,
        avatarColor: Color(0xFF48CAE4),
      ),
      const MemberData(
        name: 'Amina Juma',
        phone: '+255 765 987 654',
        payoutOrder: 3,
        hasPaid: true,
        avatarColor: Color(0xFF4ECDC4),
      ),
      _currentMember,
      const MemberData(
        name: 'Peter Osei',
        phone: '+255 789 654 321',
        payoutOrder: 5,
        hasPaid: false,
        avatarColor: Color(0xFFFFBE0B),
      ),
    ];
  }

  void _openContributionSheet() async {
    final paid = await MemberContributionSheet.show(
      context,
      group: widget.group,
      memberPhone: _currentMember.phone,
    );
    if (paid == true && mounted) {
      setState(() {
        _currentMember = MemberData(
          name: _currentMember.name,
          phone: _currentMember.phone,
          payoutOrder: _currentMember.payoutOrder,
          hasPaid: true,
          avatarColor: _currentMember.avatarColor,
        );
        final index = _members.indexWhere((m) => m.name == _currentMember.name);
        if (index != -1) {
          _members[index] = _currentMember;
        }
      });
    }
  }

  void _openReplacementAppealSheet() {
    MemberReplacementAppealSheet.show(
      context,
      group: widget.group,
      currentMember: _currentMember,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final effectivePrimary = AppColors.primaryFor(isDark);
    final g = widget.group;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      bottomNavigationBar: _buildMemberActionsBar(isDark, l10n),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor:
                isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomBackButton(
                iconColor: isDark ? Colors.white : AppColors.blackColor,
                bgColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            title: Text(
              l10n?.groupDetails ?? 'Group Details',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark ? Colors.white : AppColors.blackColor,
              ),
            ),
            centerTitle: true,
          ),

          // ── Member Status Banner ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF1E2836),
                            const Color(0xFF19222E),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.appPrimaryColor.withValues(alpha: 0.08),
                            AppColors.appPrimaryColor.withValues(alpha: 0.04),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: effectivePrimary.withValues(alpha: isDark ? 0.45 : 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: effectivePrimary.withValues(alpha: isDark ? 0.22 : 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_pin_circle_rounded,
                        color: effectivePrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.myPayoutTurn(_currentMember.payoutOrder) ??
                                'Your Payout Turn: #${_currentMember.payoutOrder}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currentMember.hasPaid
                                ? (l10n?.youHaveContributedThisRound ??
                                    'You have contributed for this round')
                                : (l10n?.pendingContributionRound(g.currentRound) ??
                                    'Pending contribution for Round ${g.currentRound}'),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: _currentMember.hasPaid
                                  ? AppColors.greenColor
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _currentMember.hasPaid
                            ? AppColors.greenColor.withValues(alpha: 0.12)
                            : Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentMember.hasPaid
                            ? (l10n?.paid ?? 'Paid')
                            : (l10n?.pendingStatus ?? 'Pending'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _currentMember.hasPaid
                              ? AppColors.greenColor
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Header Card ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: GroupHeaderCard(group: g, isDark: isDark),
            ),
          ),

          // ── Stats Grid ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GroupStatsGrid(group: g, isDark: isDark),
            ),
          ),

          // ── Progress Card ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GroupProgressCard(
                group: g,
                progress: g.totalSlots > 0 ? g.paidCount / g.totalSlots : 0.0,
                isDark: isDark,
              ),
            ),
          ),

          // ── Members Section Title ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  Text(
                    l10n?.members ?? 'Members',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          effectivePrimary.withValues(alpha: isDark ? 0.22 : 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${g.memberCount}/${g.targetMembers}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: effectivePrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // View All button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupMembersListScreen(
                          group: widget.group,
                          members: _members,
                          isLeader: false,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n?.viewAll ?? 'View All',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: effectivePrimary,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: effectivePrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Member List (Read-only for Member) ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: _members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) => GroupMemberCard(
                member: _members[i],
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Persistent bottom action bar providing the ONLY 2 member actions:
  /// 1. Swap Turn Appeal
  /// 2. Contribute
  Widget _buildMemberActionsBar(bool isDark, AppLocalizations? l10n) {
    final effectivePrimary = AppColors.primaryFor(isDark);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF22272E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Action 1: Replacement Appeal
            Expanded(
              flex: 4,
              child: OutlinedButton.icon(
                onPressed: _openReplacementAppealSheet,
                icon: Icon(
                  Icons.person_remove_rounded,
                  size: 18,
                  color: effectivePrimary,
                ),
                label: Text(
                  l10n?.replacementAppeal ?? 'Replacement Appeal',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: effectivePrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: BorderSide(
                    color: effectivePrimary.withValues(alpha: isDark ? 0.6 : 0.5),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Action 2: Contribute
            Expanded(
              flex: 5,
              child: CustomButton(
                text: l10n?.contribute ?? 'Contribute',
                height: 48,
                borderRadius: 14,
                prefixIcon: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: _openContributionSheet,
              ),
            ),
          ],
        ),
      ),
    );

  }
}
