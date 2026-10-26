import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/member/member.dart';

/// Main Dashboard container for a Member, matching KijumbeHomeScreen structure.
/// Features 3 bottom navigation tabs:
/// 1. Dashboard (`MemberDashboardScreen`): summary stats, quick actions, active groups, recent activities.
/// 2. My Groups (`MemberGroupsScreen`): exact same layout as Kijumbe with segmented tabs (All, Active, Pending), GroupListCard, FAB.
/// 3. Settings (`MemberSettingsScreen`): preferences, security, support, logout (strictly titled 'Settings').
class MemberHomeScreen extends StatefulWidget {
  final MemberProfileData? profileData;

  const MemberHomeScreen({super.key, this.profileData});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MemberDashboardScreen(
        profileData: widget.profileData,
        onNavigateToGroups: () => setState(() => _selectedIndex = 1),
      ),
      const MemberGroupsScreen(),
      MemberSettingsScreen(profileData: widget.profileData),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final navItems = [
      {
        'icon': Iconsax.home_outline,
        'activeIcon': Iconsax.home_bold,
        'label': l10n?.dashboard ?? 'Dashboard',
      },
      {
        'icon': Bootstrap.people,
        'activeIcon': Bootstrap.people_fill,
        'label': l10n?.groups ?? 'Groups',
      },
      {
        'icon': Iconsax.setting_2_outline,
        'activeIcon': Iconsax.setting_2_bold,
        'label': l10n?.settings ?? 'Settings',
      },
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      bottomNavigationBar: _buildBottomNavBar(isDark, navItems),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  Widget _buildBottomNavBar(
      bool isDark, List<Map<String, dynamic>> navItems) {
    final navBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final activeColor = AppColors.primaryFor(isDark);
    final inactiveColor = isDark
        ? Colors.white38
        : AppColors.darkGreyColor.withValues(alpha: 0.5);

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: activeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isSelected
                              ? item['activeIcon'] as IconData
                              : item['icon'] as IconData,
                          key: ValueKey('$index-$isSelected'),
                          color: isSelected ? activeColor : inactiveColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
