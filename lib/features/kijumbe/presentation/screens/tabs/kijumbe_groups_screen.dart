import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/components/components.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/create_group_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/group_list_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_summary_chips.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class KijumbeGroupsScreen extends StatefulWidget {
  const KijumbeGroupsScreen({super.key});

  @override
  State<KijumbeGroupsScreen> createState() => _KijumbeGroupsScreenState();
}

class _KijumbeGroupsScreenState extends State<KijumbeGroupsScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Mock data ─────────────────────────────────────────────────────────────
  final List<GroupsListItem> _groups = const [
    GroupsListItem(
      name: 'Family Welfare Circle',
      memberCount: 8,
      targetMembers: 12,
      contribution: 'TZS 50,000',
      frequency: 'Monthly',
      paidCount: 6,
      totalSlots: 12,
      nextContribution: 'Mar 10',
      totalPot: 'TZS 600,000',
      status: GroupItemStatus.active,
      avatarColors: [AppColors.appPrimaryColor, Color(0xFF4ECDC4), Color(0xFFFF6B6B)],
      currentRound: 4,
      kijumbeName: 'Vallerian',
    ),
    GroupsListItem(
      name: 'Business Growth Fund',
      memberCount: 5,
      targetMembers: 10,
      contribution: 'TZS 30,000',
      frequency: 'Weekly',
      paidCount: 3,
      totalSlots: 10,
      nextContribution: 'Mar 15',
      totalPot: 'TZS 300,000',
      status: GroupItemStatus.active,
      avatarColors: [Color(0xFF845EC2), Color(0xFFD65DB1), Color(0xFFFF9671)],
      currentRound: 2,
      kijumbeName: 'Vallerian',
    ),
    GroupsListItem(
      name: 'Weekend Hustle Chama',
      memberCount: 4,
      targetMembers: 8,
      contribution: 'TZS 20,000',
      frequency: 'Bi-weekly',
      paidCount: 2,
      totalSlots: 8,
      nextContribution: 'Apr 1',
      totalPot: 'TZS 160,000',
      status: GroupItemStatus.pending,
      avatarColors: [Color(0xFF00C9A7), Color(0xFFC4FCEF), Color(0xFF4D8076)],
      currentRound: 1,
      kijumbeName: 'Vallerian',
    ),
  ];

  List<GroupsListItem> get _filteredGroups {
    List<GroupsListItem> list = _groups;
    if (_selectedTabIndex == 1) {
      list = _groups
          .where((g) => g.status == GroupItemStatus.active)
          .toList();
    } else if (_selectedTabIndex == 2) {
      list = _groups
          .where((g) => g.status == GroupItemStatus.pending)
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((g) =>
          g.name.toLowerCase().contains(q) ||
          g.kijumbeName.toLowerCase().contains(q)).toList();
    }
    return list;
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CreateGroupScreen(),
          ),
        ),
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
              const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n?.createNewGroup ?? 'New Group',
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

          // ── Search Bar Input ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: CustomSearchBar(
                controller: _searchController,
                hintText: l10n?.searchGroups ?? 'Search groups...',
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onClear: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            ),
          ),

          // ── iOS Segmented Tab Bar ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

          // ── Group list / Empty State ────────────────────────────────────────
          if (_filteredGroups.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.search_status_outline,
                          size: 30,
                          color: isDark ? Colors.white38 : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n?.noGroupsFound ?? 'No groups found',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'No groups match "$_searchQuery"'
                            : 'No groups under this category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n?.clearFilters ?? 'Clear Search',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryFor(isDark),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              sliver: SliverList.separated(
                itemCount: _filteredGroups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (ctx, i) => GroupListCard(
                  group: _filteredGroups[i],
                  isDark: isDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
