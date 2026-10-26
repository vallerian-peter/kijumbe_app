import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/kijumbe.dart';

class KijumbeHomeScreen extends StatefulWidget {
  const KijumbeHomeScreen({super.key});

  @override
  State<KijumbeHomeScreen> createState() => _KijumbeHomeScreenState();
}

class _KijumbeHomeScreenState extends State<KijumbeHomeScreen> {
  int selectedIndex = 0;

  // Kijumbe's name – replace with actual user data from provider later
  static const String _kijumbeName = 'Emmanuel';

  final List<Map<String, dynamic>> _screensData = [
    {
      "screen": KijumbeDashboardScreen(),
      "icon": Iconsax.home_outline,
      "activeIcon": Iconsax.home_bold,
      "label": "Dashboard",
    },
    {
      "screen": KijumbeGroupsScreen(),
      "icon": Bootstrap.people,
      "activeIcon": Bootstrap.people_fill,
      "label": "Groups",
    },
    {
      "screen": KijumbeSettingsScreen(),
      "icon": Ionicons.personOutline,
      "activeIcon": Ionicons.person,
      "label": "Profile",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      bottomNavigationBar: _buildBottomNavBar(isDark),
      body: _screensData[selectedIndex]['screen'],
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    final navBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final activeColor = AppColors.primaryColor;
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
            children: _screensData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = selectedIndex == index;
              final isProfile = index == _screensData.length - 1;

              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: activeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile tab shows CircleAvatar instead of icon
                      if (isProfile)
                        _buildProfileNavAvatar(isSelected, activeColor, inactiveColor)
                      else
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isSelected
                                ? item['activeIcon'] as IconData
                                : item['icon'] as IconData,
                            key: ValueKey(isSelected),
                            color: isSelected ? activeColor : inactiveColor,
                            size: 24,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
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

  Widget _buildProfileNavAvatar(
      bool isSelected, Color activeColor, Color inactiveColor) {
    final initial = _kijumbeName.isNotEmpty
        ? _kijumbeName[0].toUpperCase()
        : 'K';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected ? AppColors.primaryTealGradient : null,
        color: isSelected ? null : inactiveColor.withValues(alpha: 0.15),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : inactiveColor.withValues(alpha: 0.4),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : inactiveColor,
          ),
        ),
      ),
    );
  }
}
