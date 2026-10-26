import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_activity_tile.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_create_group_button.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_group_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_pending_actions_banner.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_section_header.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_sliver_app_bar.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_summary_stats.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';
import '../kijumbe_group_detail_screen.dart';
import '../make_contribution_screen.dart';

class KijumbeDashboardScreen extends StatefulWidget {
  const KijumbeDashboardScreen({super.key});

  @override
  State<KijumbeDashboardScreen> createState() => _KijumbeDashboardScreenState();
}

class _KijumbeDashboardScreenState extends State<KijumbeDashboardScreen> {
  // ── Mock data (replace with provider/state later) ─────────────────────────
  final String _kijumbeName = 'Vallerian';
  final String _totalBalance = 'TZS 2,450,000';
  final int _activeGroups = 3;
  final int _totalMembers = 24;
  final int _currentRound = 4;
  final int _pendingActions = 2;

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
      currentRound: _currentRound,
      kijumbeName: _kijumbeName,
    );
  }

  List<DashboardQuickAction> _getQuickActions(
      BuildContext context, AppLocalizations? l10n) {
    return [
      DashboardQuickAction(
        icon: Iconsax.send_2_outline,
        label: l10n?.send ?? 'Send',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n?.send ?? 'Send'} - Coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      DashboardQuickAction(
        icon: Iconsax.received_outline,
        label: l10n?.request ?? 'Request',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n?.request ?? 'Request'} - Coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      DashboardQuickAction(
        icon: Iconsax.money_recive_outline,
        label: l10n?.contribute ?? 'Contribute',
        onTap: () {
          if (_activeGroupsList.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MakeContributionScreen(
                  group: _toGroupData(_activeGroupsList.first),
                ),
              ),
            );
          }
        },
      ),
      DashboardQuickAction(
        icon: Iconsax.moneys_outline,
        label: l10n?.cashOut ?? 'Cash Out',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n?.cashOut ?? 'Cash Out'} - Coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    ];
  }

  final List<DashboardGroupSummary> _activeGroupsList = const [
    DashboardGroupSummary(
      name: 'Family Circle',
      memberCount: 8,
      targetMembers: 10,
      contributionAmount: 'TZS 50,000',
      frequency: 'cycle',
      paidCount: 4,
      totalSlots: 6,
      nextPayout: 'Mar 15, 2026',
      totalPot: 'TZS 400,000',
      avatarColors: [
        AppColors.appPrimaryColor,
        Color(0xFFFF6B6B),
        Color(0xFF4ECDC4),
        Color(0xFFFFBE0B),
      ],
    ),
    DashboardGroupSummary(
      name: 'Work Savings',
      memberCount: 6,
      targetMembers: 10,
      contributionAmount: 'TZS 30,000',
      frequency: 'weekly',
      paidCount: 5,
      totalSlots: 6,
      nextPayout: 'Mar 20, 2026',
      totalPot: 'TZS 180,000',
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
      name: 'Family Circle',
      subtitle: 'Contribution received',
      date: 'Today • 9:00 AM',
      amount: '+TZS 50,000',
      isCredit: true,
      type: DashboardActivityType.group,
    ),
    DashboardActivityItem(
      name: 'John Doe',
      subtitle: 'Payment for member',
      date: 'Yesterday • 11:00 AM',
      amount: '+TZS 30,000',
      isCredit: true,
      type: DashboardActivityType.received,
    ),
    DashboardActivityItem(
      name: 'Maria Santos',
      subtitle: 'Penalty deducted',
      date: 'Feb 17 • 2:00 PM',
      amount: '-TZS 5,000',
      isCredit: false,
      type: DashboardActivityType.sent,
    ),
    DashboardActivityItem(
      name: 'Work Savings',
      subtitle: 'Round 4 payout',
      date: 'Feb 15 • 9:00 AM',
      amount: '+TZS 180,000',
      isCredit: true,
      type: DashboardActivityType.group,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          DashboardSliverAppBar(
            kijumbeName: _kijumbeName,
            totalBalance: _totalBalance,
            pendingActions: _pendingActions,
            quickActions: _getQuickActions(context, l10n),
            isDark: isDark,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  DashboardSummaryStats(
                    activeGroups: _activeGroups,
                    totalMembers: _totalMembers,
                    currentRound: _currentRound,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  if (_pendingActions > 0) ...[
                    DashboardPendingActionsBanner(
                      pendingActions: _pendingActions,
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                  ],
                  DashboardSectionHeader(
                    title: l10n?.activeGroups ?? 'Active Groups',
                    actionLabel: l10n?.viewAll ?? 'View all',
                    onAction: () {},
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DashboardCreateGroupButton(isDark: isDark),
                  const SizedBox(height: 24),
                  DashboardSectionHeader(
                    title: l10n?.recentActivity ?? 'Recent Activity',
                    actionLabel: l10n?.viewAll ?? 'View all',
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
