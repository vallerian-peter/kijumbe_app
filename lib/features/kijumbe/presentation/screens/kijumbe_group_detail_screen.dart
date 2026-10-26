import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_back_button.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/invite_members_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/make_contribution_screen.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_add_member_sheet.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_header_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_member_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_options_sheet.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_progress_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/group_stats_grid.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/group_detail/kijumbe_swap_turns_sheet.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

// ── Public Models ────────────────────────────────────────────────────────────
class GroupData {
  final String name;
  final int memberCount;
  final int targetMembers;
  final String contribution;
  final String frequency;
  final int paidCount;
  final int totalSlots;
  final String nextContribution;
  final String totalPot;
  final String status;
  final List<Color> avatarColors;
  final int currentRound;
  final String kijumbeName;

  const GroupData({
    required this.name,
    required this.memberCount,
    required this.targetMembers,
    required this.contribution,
    required this.frequency,
    required this.paidCount,
    required this.totalSlots,
    required this.nextContribution,
    required this.totalPot,
    required this.status,
    required this.avatarColors,
    required this.currentRound,
    required this.kijumbeName,
  });
}

class MemberData {
  final String name;
  final String phone;
  final int payoutOrder;
  final bool hasPaid;
  final Color avatarColor;
  final bool isKijumbe;

  const MemberData({
    required this.name,
    required this.phone,
    required this.payoutOrder,
    required this.hasPaid,
    required this.avatarColor,
    this.isKijumbe = false,
  });

  MemberData copyWith({
    String? name,
    String? phone,
    int? payoutOrder,
    bool? hasPaid,
    Color? avatarColor,
    bool? isKijumbe,
  }) {
    return MemberData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      payoutOrder: payoutOrder ?? this.payoutOrder,
      hasPaid: hasPaid ?? this.hasPaid,
      avatarColor: avatarColor ?? this.avatarColor,
      isKijumbe: isKijumbe ?? this.isKijumbe,
    );
  }
}

// ── Group Detail Screen (Clean Orchestrator) ──────────────────────────────────
class KijumbeGroupDetailScreen extends StatefulWidget {
  final GroupData group;
  const KijumbeGroupDetailScreen({super.key, required this.group});

  @override
  State<KijumbeGroupDetailScreen> createState() =>
      _KijumbeGroupDetailScreenState();
}

class _KijumbeGroupDetailScreenState extends State<KijumbeGroupDetailScreen> {
  late final List<MemberData> _members;

  @override
  void initState() {
    super.initState();
    _members = [
      MemberData(
        name: 'Vallerian Mchau',
        phone: '+255 712 345 678',
        payoutOrder: 1,
        hasPaid: true,
        avatarColor: widget.group.avatarColors[0],
        isKijumbe: true,
      ),
      MemberData(
        name: 'John Makinde',
        phone: '+255 754 123 456',
        payoutOrder: 2,
        hasPaid: true,
        avatarColor:
            widget.group.avatarColors[1 % widget.group.avatarColors.length],
      ),
      MemberData(
        name: 'Amina Juma',
        phone: '+255 765 987 654',
        payoutOrder: 3,
        hasPaid: false,
        avatarColor:
            widget.group.avatarColors[2 % widget.group.avatarColors.length],
      ),
      const MemberData(
        name: 'Peter Osei',
        phone: '+255 789 654 321',
        payoutOrder: 4,
        hasPaid: true,
        avatarColor: Color(0xFFFFBE0B),
      ),
      const MemberData(
        name: 'Grace Msimbe',
        phone: '+255 713 111 222',
        payoutOrder: 5,
        hasPaid: false,
        avatarColor: Color(0xFFFF6B6B),
      ),
    ];
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

  void _showOptions(BuildContext context, bool isDark) {
    GroupOptionsSheet.show(
      context,
      group: widget.group,
      isDark: isDark,
      onSwapTurns: _openSwapTurnsSheet,
      onQuickInvite: () => GroupAddMemberSheet.show(
        context,
        isDark: isDark,
        onAddMember: (phone) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invitation sent to $phone!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final g = widget.group;
    final progress = g.totalSlots > 0 ? g.paidCount / g.totalSlots : 0.0;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Clean Details Top Bar ─────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            elevation: 0,
            scrolledUnderElevation: 0,
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.blackColor,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: isDark ? Colors.white : AppColors.blackColor,
                      size: 20,
                    ),
                  ),
                  onPressed: () => _showOptions(context, isDark),
                ),
              ),
            ],
          ),

          // ── Details Content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Group Header Card
                  GroupHeaderCard(group: g, isDark: isDark),

                  // 2. Stats Grid
                  GroupStatsGrid(group: g, isDark: isDark),

                  // 3. Progress bar card
                  GroupProgressCard(
                    group: g,
                    progress: progress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),

                  // 3.5 Make Contribution CTA Button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MakeContributionScreen(
                          group: widget.group,
                          members: _members,
                        ),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryButtonGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor
                                .withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n?.makeContribution ?? 'Make Contribution'} (${g.contribution})',
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
                  const SizedBox(height: 24),

                  // 4. Members Section Header
                  Row(
                    children: [
                      Text(
                        l10n?.members ?? 'Members',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? Colors.white : AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${g.memberCount}/${g.targetMembers}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Swap Turns Controller button (compact icon button with tooltip)
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
                      const SizedBox(width: 8),
                      // Add Member button
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                InviteMembersScreen(group: widget.group),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryButtonGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_add_alt_1_rounded,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                l10n?.addMember ?? 'Add Member',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ── Member List ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList.separated(
              itemCount: _members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) => GroupMemberCard(
                member: _members[i],
                isDark: isDark,
                onRemind: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${l10n?.reminderSentTo ?? 'Reminder sent to'} ${_members[i].name}',
                      ),
                      behavior: SnackBarBehavior.floating,
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
