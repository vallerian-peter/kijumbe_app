import 'package:flutter/material.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/groups/groups_models.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupsIosTabBar extends StatelessWidget {
  final List<GroupsListItem> groups;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const GroupsIosTabBar({
    super.key,
    required this.groups,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeCount =
        groups.where((g) => g.status == GroupItemStatus.active).length;
    final pendingCount =
        groups.where((g) => g.status == GroupItemStatus.pending).length;

    final tabs = [
      _TabOption(label: l10n?.allGroups ?? 'All', count: groups.length),
      _TabOption(label: l10n?.activeTab ?? 'Active', count: activeCount),
      _TabOption(label: l10n?.pendingTab ?? 'Pending', count: pendingCount),
    ];

    final containerBg =
        isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF3A3A3C) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7.5),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.35 : 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1.5),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        tab.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark
                                  ? Colors.white54
                                  : const Color(0xFF8E8E93)),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.06))
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${tab.count}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.white : Colors.black)
                              : (isDark
                                  ? Colors.white54
                                  : const Color(0xFF8E8E93)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabOption {
  final String label;
  final int count;

  const _TabOption({required this.label, required this.count});
}

/// Backward compatibility alias for existing code/tests
class GroupsSummaryChips extends StatelessWidget {
  final List<GroupsListItem> groups;
  final bool isDark;

  const GroupsSummaryChips({
    super.key,
    required this.groups,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GroupsIosTabBar(
      groups: groups,
      selectedIndex: 0,
      onTabSelected: (_) {},
      isDark: isDark,
    );
  }
}
