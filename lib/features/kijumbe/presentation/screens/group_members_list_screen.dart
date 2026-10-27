import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/components/components.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/invite_members_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/kijumbe_swap_turns_sheet.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

enum MemberFilterOption { all, paid, pending }

/// A dedicated screen displaying all group members with quick search,
/// category filter pills, rich member cards, and role-appropriate actions.
class GroupMembersListScreen extends StatefulWidget {
  final GroupData group;
  final List<MemberData> members;
  final bool isLeader;

  const GroupMembersListScreen({
    super.key,
    required this.group,
    required this.members,
    this.isLeader = false,
  });

  @override
  State<GroupMembersListScreen> createState() => _GroupMembersListScreenState();
}

class _GroupMembersListScreenState extends State<GroupMembersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  MemberFilterOption _activeFilter = MemberFilterOption.all;
  late List<MemberData> _members;

  @override
  void initState() {
    super.initState();
    _members = List.from(widget.members);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSwapTurnsSheet() {
    KijumbeSwapTurnsSheet.show(
      context,
      group: widget.group,
      members: _members,
      onTurnsSwapped: (memberA, memberB) {
        final indexA = _members.indexWhere((m) => m.name == memberA.name);
        final indexB = _members.indexWhere((m) => m.name == memberB.name);
        if (indexA == -1 || indexB == -1) return;

        final orderA = memberA.payoutOrder;
        final orderB = memberB.payoutOrder;

        setState(() {
          _members[indexA] = memberA.copyWith(payoutOrder: orderB);
          _members[indexB] = memberB.copyWith(payoutOrder: orderA);
          _members.sort((a, b) => a.payoutOrder.compareTo(b.payoutOrder));
        });
      },
    );
  }

  List<MemberData> get _filteredMembers {
    return _members.where((member) {
      // 1. Filter by status pill
      if (_activeFilter == MemberFilterOption.paid && !member.hasPaid) {
        return false;
      }
      if (_activeFilter == MemberFilterOption.pending && member.hasPaid) {
        return false;
      }

      // 2. Filter by search query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final nameMatch = member.name.toLowerCase().contains(query);
        final phoneMatch = member.phone.replaceAll(' ', '').contains(query.replaceAll(' ', ''));
        return nameMatch || phoneMatch;
      }

      return true;
    }).toList();
  }

  int get _paidCount => _members.where((m) => m.hasPaid).length;
  int get _pendingCount => _members.where((m) => !m.hasPaid).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final effectivePrimary = AppColors.primaryFor(isDark);

    final filtered = _filteredMembers;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      floatingActionButton: widget.isLeader
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InviteMembersScreen(group: widget.group),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              extendedPadding: EdgeInsets.zero,
              label: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryButtonGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_alt_1_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      l10n?.addMember ?? 'Add Member',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 8),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.allMembers ?? 'All Members',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.group.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: effectivePrimary.withValues(alpha: isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: effectivePrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${_members.length}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: effectivePrimary,
                      ),
                    ),
                  ),
                  if (widget.isLeader) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: l10n?.swapMemberTurns ?? 'Swap Turns',
                      child: GestureDetector(
                        onTap: _openSwapTurnsSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Icon(
                            Icons.swap_vert_rounded,
                            color: isDark
                                ? Colors.white
                                : AppColors.appPrimaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Search Bar Input ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: CustomSearchBar(
                controller: _searchController,
                hintText: l10n?.searchMembers ?? 'Search members...',
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

            // ── Filter Pills ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterPill(
                    label: '${l10n?.filterAll ?? 'All'} (${_members.length})',
                    option: MemberFilterOption.all,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterPill(
                    label: '${l10n?.filterPaid ?? 'Paid'} ($_paidCount)',
                    option: MemberFilterOption.paid,
                    isDark: isDark,
                    color: const Color(0xFF2EC4B6),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterPill(
                    label: '${l10n?.filterPending ?? 'Pending'} ($_pendingCount)',
                    option: MemberFilterOption.pending,
                    isDark: isDark,
                    color: const Color(0xFFFF9F1C),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Members List / Empty State ─────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState(isDark, l10n)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) {
                        final member = filtered[i];
                        return _buildMemberCard(member, isDark, l10n);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required MemberFilterOption option,
    required bool isDark,
    Color? color,
  }) {
    final isSelected = _activeFilter == option;
    final primary = color ?? AppColors.primaryFor(isDark);

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = option;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : (isDark
                  ? const Color(0xFF22272E)
                  : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primary
                : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : AppColors.darkGreyColor),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(MemberData member, bool isDark, AppLocalizations? l10n) {
    final effectivePrimary = AppColors.primaryFor(isDark);
    final cardBg = isDark ? const Color(0xFF22272E) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.07) : const Color(0xFFEAEAEA);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with turn badge or crown
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: member.avatarColor.withValues(alpha: 0.2),
                child: Text(
                  member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: member.avatarColor,
                  ),
                ),
              ),
              if (member.isKijumbe)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB703),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Name, phone, and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                      ),
                    ),
                    if (member.isKijumbe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB703).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Leader',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD48B00),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      member.phone,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white30 : Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n?.turnOrder(member.payoutOrder) ?? 'Turn #${member.payoutOrder}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: effectivePrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status Badge + Leader Remind Action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: member.hasPaid
                      ? const Color(0xFF2EC4B6).withValues(alpha: 0.12)
                      : const Color(0xFFFF9F1C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: member.hasPaid
                        ? const Color(0xFF2EC4B6).withValues(alpha: 0.3)
                        : const Color(0xFFFF9F1C).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      member.hasPaid
                          ? Icons.check_circle_rounded
                          : Icons.access_time_rounded,
                      size: 13,
                      color: member.hasPaid
                          ? const Color(0xFF2EC4B6)
                          : const Color(0xFFFF9F1C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      member.hasPaid
                          ? (l10n?.filterPaid ?? 'Paid')
                          : (l10n?.filterPending ?? 'Pending'),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: member.hasPaid
                            ? const Color(0xFF2EC4B6)
                            : const Color(0xFFFF9F1C),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isLeader && !member.hasPaid) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${l10n?.reminderSentTo ?? 'Reminder sent to'} ${member.name}',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: effectivePrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          size: 12,
                          color: effectivePrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n?.remind ?? 'Remind',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: effectivePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations? l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.search_status_outline,
                size: 32,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.noMembersFound ?? 'No members found',
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
                  ? 'No results match "$_searchQuery"'
                  : 'No members under the selected filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
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
    );
  }
}
