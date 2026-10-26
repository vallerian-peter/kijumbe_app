import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/group_list_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_summary_chips.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Full-featured Groups Screen for Members matching KijumbeGroupsScreen layout.
/// Features iOS Segmented Tab Bar (All, Active, Pending), GroupListCards,
/// and Floating Action Button to Join Group via code.
class MemberGroupsScreen extends StatefulWidget {
  const MemberGroupsScreen({super.key});

  @override
  State<MemberGroupsScreen> createState() => _MemberGroupsScreenState();
}

class _MemberGroupsScreenState extends State<MemberGroupsScreen> {
  int _selectedTabIndex = 0;

  final List<GroupsListItem> _groups = [
    const GroupsListItem(
      name: 'Upendo Women Savings',
      memberCount: 5,
      targetMembers: 6,
      contribution: 'TZS 50,000',
      frequency: 'Monthly',
      paidCount: 4,
      totalSlots: 6,
      nextContribution: '15 Oct, 2024',
      totalPot: 'TZS 300,000',
      status: GroupItemStatus.active,
      avatarColors: [
        AppColors.appPrimaryColor,
        Color(0xFF48CAE4),
        Color(0xFF4ECDC4),
        Color(0xFFFFBE0B),
      ],
      currentRound: 3,
      kijumbeName: 'Vallerian Mchau',
    ),
    const GroupsListItem(
      name: 'Boda Boda Kinondoni',
      memberCount: 8,
      targetMembers: 10,
      contribution: 'TZS 20,000',
      frequency: 'Weekly',
      paidCount: 7,
      totalSlots: 10,
      nextContribution: '18 Oct, 2024',
      totalPot: 'TZS 200,000',
      status: GroupItemStatus.active,
      avatarColors: [
        Color(0xFF845EC2),
        Color(0xFFD65DB1),
        Color(0xFFFF9671),
        Color(0xFF00C9A7),
      ],
      currentRound: 2,
      kijumbeName: 'Hamisi Bakari',
    ),
    const GroupsListItem(
      name: 'Mwananyamala Market Chama',
      memberCount: 3,
      targetMembers: 8,
      contribution: 'TZS 30,000',
      frequency: 'Bi-weekly',
      paidCount: 1,
      totalSlots: 8,
      nextContribution: '25 Oct, 2024',
      totalPot: 'TZS 240,000',
      status: GroupItemStatus.pending,
      avatarColors: [
        Color(0xFF00C9A7),
        Color(0xFFC4FCEF),
        Color(0xFF4D8076),
      ],
      currentRound: 1,
      kijumbeName: 'Grace Mlay',
    ),
  ];

  List<GroupsListItem> get _filteredGroups {
    if (_selectedTabIndex == 1) {
      return _groups
          .where((g) => g.status == GroupItemStatus.active)
          .toList();
    } else if (_selectedTabIndex == 2) {
      return _groups
          .where((g) => g.status == GroupItemStatus.pending)
          .toList();
    }
    return _groups;
  }

  GroupData _toGroupData(GroupsListItem item) {
    return GroupData(
      name: item.name,
      memberCount: item.memberCount,
      targetMembers: item.targetMembers,
      contribution: item.contribution,
      frequency: item.frequency,
      paidCount: item.paidCount,
      totalSlots: item.totalSlots,
      nextContribution: item.nextContribution,
      totalPot: item.totalPot,
      status: item.status == GroupItemStatus.active ? 'Active' : 'Pending',
      avatarColors: item.avatarColors,
      currentRound: item.currentRound,
      kijumbeName: item.kijumbeName,
    );
  }

  void _openJoinGroupSheet() {
    MemberJoinGroupSheet.show(
      context,
      onGroupJoined: (code) async {
        final l10n = AppLocalizations.of(context);
        await MemberFullScreenLoading.show<void>(
          context,
          title: l10n?.joiningGroupTitle ?? 'Joining Group...',
          description: l10n?.joiningGroupDesc ??
              'Verifying group code and setting up your membership. Please wait...',
          asyncTask: () => Future.delayed(const Duration(milliseconds: 1400)),
        );

        if (!mounted) return;

        final newGroupItem = GroupsListItem(
          name: 'Kijumbe Savings #$code',
          memberCount: 6,
          targetMembers: 8,
          contribution: 'TZS 30,000',
          frequency: 'Monthly',
          paidCount: 5,
          totalSlots: 8,
          nextContribution: '20 Oct, 2024',
          totalPot: 'TZS 240,000',
          status: GroupItemStatus.active,
          avatarColors: const [
            Color(0xFF00B4D8),
            Color(0xFF48CAE4),
            Color(0xFF6C5CE7),
            Color(0xFFFFBE0B),
          ],
          currentRound: 1,
          kijumbeName: 'Baraka Paul',
        );

        setState(() {
          _groups.insert(0, newGroupItem);
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MemberGroupDetailScreen(
              group: _toGroupData(newGroupItem),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openJoinGroupSheet,
        backgroundColor: Colors.transparent,
        elevation: 0,
        extendedPadding: EdgeInsets.zero,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.45),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n?.joinGroup ?? 'Join Group',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── AppBar ─────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor:
                isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n?.myGroups ?? 'My Groups',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.blackColor,
              ),
            ),
          ),

          // ── iOS Segmented Tab Bar ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GroupsIosTabBar(
                groups: _groups,
                selectedIndex: _selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                isDark: isDark,
              ),
            ),
          ),

          // ── Group list ──────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            sliver: SliverList.separated(
              itemCount: _filteredGroups.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (ctx, i) => GroupListCard(
                group: _filteredGroups[i],
                isDark: isDark,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MemberGroupDetailScreen(
                        group: _toGroupData(_filteredGroups[i]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
