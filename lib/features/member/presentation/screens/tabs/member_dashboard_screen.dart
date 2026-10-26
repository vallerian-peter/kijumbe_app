import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/localization/app_locale.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/kijumbe.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/l10n/l10n.dart';

/// Personalized Dashboard for a Kikoba Member.
/// Designed specifically for member fintech behavior:
/// - Balance card displays member's personal savings (NOT the group's total pool balance).
/// - Quick actions tailored for members: Contribute, Swap Turn, Join Group, Statement.
///   (No Cash Out, No Request, No Send).
/// - Stats display member's personal progress: Active Groups, Contributions Paid, My Turn
///   (No member management status).
class MemberDashboardScreen extends StatefulWidget {
  final MemberProfileData? profileData;
  final VoidCallback? onNavigateToGroups;

  const MemberDashboardScreen({
    super.key,
    this.profileData,
    this.onNavigateToGroups,
  });

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  late String _memberName;
  final String _personalSavings = 'TZS 180,000';
  final int _activeGroups = 2;
  final int _paidContributions = 11;
  final int _totalTargetContributions = 12;
  final int _myTurn = 3;
  final int _pendingActions = 1;

  @override
  void initState() {
    super.initState();
    _memberName = widget.profileData?.firstName.isNotEmpty == true
        ? widget.profileData!.firstName
        : 'Salma';
  }

  GroupData _toGroupData(DashboardGroupSummary g) {
    return GroupData(
      name: g.name,
      memberCount: g.memberCount,
      targetMembers: g.targetMembers,
      contribution: g.contributionAmount,
      frequency: g.frequency,
      paidCount: g.paidCount,
      totalSlots: g.totalSlots,
      nextContribution: g.nextPayout,
      totalPot: g.totalPot,
      status: 'Active',
      avatarColors: g.avatarColors,
      currentRound: _myTurn,
      kijumbeName: 'Vallerian Mchau',
    );
  }

  List<DashboardQuickAction> _getQuickActions(
      BuildContext context, AppLocalizations? l10n) {
    final isSw = Localizations.localeOf(context).languageCode == 'sw';
    return [
      DashboardQuickAction(
        icon: Iconsax.money_recive_outline,
        label: l10n?.contribute ?? 'Contribute',
        onTap: () {
          if (_activeGroupsList.isNotEmpty) {
            MemberContributionSheet.show(
              context,
              group: _toGroupData(_activeGroupsList.first),
              memberPhone: widget.profileData?.displayPhone ?? '+255 712 345 678',
            );
          }
        },
      ),
      DashboardQuickAction(
        icon: Iconsax.arrow_swap_horizontal_outline,
        label: l10n?.replacementAppeal ?? 'Replacement Appeal',
        onTap: () {
          if (_activeGroupsList.isNotEmpty) {
            final grp = _toGroupData(_activeGroupsList.first);
            MemberSwapAppealSheet.show(
              context,
              group: grp,
              members: [
                MemberData(
                  name: _memberName,
                  phone: '+255 712 345 678',
                  payoutOrder: _myTurn,
                  hasPaid: true,
                  avatarColor: AppColors.appPrimaryColor,
                ),
                const MemberData(
                  name: 'Amina Juma',
                  phone: '+255 714 555 111',
                  payoutOrder: 1,
                  hasPaid: true,
                  avatarColor: Color(0xFF48CAE4),
                ),
                const MemberData(
                  name: 'Zuhura Bakari',
                  phone: '+255 713 222 333',
                  payoutOrder: 2,
                  hasPaid: true,
                  avatarColor: Color(0xFF6C5CE7),
                ),
              ],
              currentMember: MemberData(
                name: _memberName,
                phone: '+255 712 345 678',
                payoutOrder: _myTurn,
                hasPaid: true,
                avatarColor: AppColors.appPrimaryColor,
              ),
            );
          }
        },
      ),
      DashboardQuickAction(
        icon: Icons.vpn_key_outlined,
        label: isSw ? 'Jiunge' : 'Join Group',
        onTap: () {
          MemberJoinGroupSheet.show(context);
        },
      ),
      DashboardQuickAction(
        icon: Iconsax.receipt_2_outline,
        label: isSw ? 'Taarifa' : 'Activity',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${isSw ? 'Taarifa za Hivi Karibuni' : 'Recent Activity'}: ${_recentActivity.length} recent transactions recorded',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ];
  }

  final List<DashboardGroupSummary> _activeGroupsList = const [
    DashboardGroupSummary(
      name: 'Upendo Women Savings',
      memberCount: 5,
      targetMembers: 6,
      contributionAmount: 'TZS 50,000',
      frequency: 'cycle',
      paidCount: 4,
      totalSlots: 6,
      nextPayout: '15 Oct, 2024',
      totalPot: 'TZS 300,000',
      avatarColors: [
        AppColors.appPrimaryColor,
        Color(0xFF48CAE4),
        Color(0xFF4ECDC4),
        Color(0xFFFFBE0B),
      ],
    ),
    DashboardGroupSummary(
      name: 'Boda Boda Kinondoni',
      memberCount: 8,
      targetMembers: 10,
      contributionAmount: 'TZS 20,000',
      frequency: 'weekly',
      paidCount: 7,
      totalSlots: 10,
      nextPayout: '18 Oct, 2024',
      totalPot: 'TZS 200,000',
      avatarColors: [
        Color(0xFF845EC2),
        Color(0xFFD65DB1),
        Color(0xFFFF9671),
        Color(0xFF00C9A7),
      ],
    ),
  ];

  final List<DashboardActivityItem> _recentActivity = const [
    DashboardActivityItem(
      name: 'Upendo Women Savings',
      subtitle: 'Contribution paid',
      date: 'Today • 10:30 AM',
      amount: '-TZS 50,000',
      isCredit: false,
      type: DashboardActivityType.sent,
    ),
    DashboardActivityItem(
      name: 'Boda Boda Kinondoni',
      subtitle: 'Payout received',
      date: 'Yesterday • 2:15 PM',
      amount: '+TZS 200,000',
      isCredit: true,
      type: DashboardActivityType.group,
    ),
    DashboardActivityItem(
      name: 'Upendo Women Savings',
      subtitle: 'Monthly cycle contribution',
      date: '15 Sep • 9:00 AM',
      amount: '-TZS 50,000',
      isCredit: false,
      type: DashboardActivityType.sent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Dashboard Sliver AppBar with Member's Personal Savings ──────────
          DashboardSliverAppBar(
            kijumbeName: _memberName,
            totalBalance: _personalSavings,
            balanceTitle: l10n.myTotalSavings,
            appSubtitle: l10n.kikobaMember,
            pendingActions: _pendingActions,
            quickActions: _getQuickActions(context, l10n),
            isDark: isDark,
            onAvatarTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MemberProfileScreen(
                    profileData: widget.profileData,
                  ),
                ),
              );
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Member Personalized Summary Stats (No Member Status) ─
                  MemberSummaryStats(
                    activeGroups: _activeGroups,
                    paidContributions: _paidContributions,
                    totalTargetContributions: _totalTargetContributions,
                    myTurn: _myTurn,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // ── Pending Actions Banner ────────────────────────────────
                  if (_pendingActions > 0) ...[
                    DashboardPendingActionsBanner(
                      pendingActions: _pendingActions,
                      onTap: () {
                        if (_activeGroupsList.isNotEmpty) {
                          MemberContributionSheet.show(
                            context,
                            group: _toGroupData(_activeGroupsList.first),
                            memberPhone: widget.profileData?.displayPhone ??
                                '+255 712 345 678',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Active Groups Section ──────────────────────────────────
                  DashboardSectionHeader(
                    title: l10n.activeGroups,
                    actionLabel: l10n.viewAll,
                    onAction: widget.onNavigateToGroups ?? () {},
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _activeGroupsList.length,
                      itemBuilder: (ctx, i) => DashboardGroupCard(
                        group: _activeGroupsList[i],
                        isDark: isDark,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MemberGroupDetailScreen(
                                group: _toGroupData(_activeGroupsList[i]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Join Group Button ──────────────────────────────────────
                  MemberJoinGroupButton(isDark: isDark),

                  const SizedBox(height: 24),

                  // ── Recent Activity Section ────────────────────────────────
                  DashboardSectionHeader(
                    title: l10n.recentActivity,
                    actionLabel: l10n.viewAll,
                    onAction: () {},
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),

                  ..._recentActivity.map(
                    (item) => DashboardActivityTile(
                      item: item,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
