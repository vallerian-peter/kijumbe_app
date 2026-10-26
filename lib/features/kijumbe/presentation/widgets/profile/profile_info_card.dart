import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/core.dart';

class ProfileInfoItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const ProfileInfoItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.onEdit,
  });
}

class ProfileSectionLabel extends StatelessWidget {
  final String label;

  const ProfileSectionLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark
            ? Colors.white54
            : AppColors.darkGreyColor.withValues(alpha: 0.55),
        letterSpacing: 0.4,
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final List<ProfileInfoItem> items;

  const ProfileInfoCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: item.iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(item.icon, color: item.iconColor, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.onEdit != null) ...[
                      const SizedBox(width: 8),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: item.onEdit,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.06),
                                width: 0.8,
                              ),
                            ),
                            child: Icon(
                              Iconsax.edit_2_outline,
                              size: 15,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.darkGreyColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 0.6,
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
