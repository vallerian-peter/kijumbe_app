import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/dashboard/dashboard_models.dart';

class DashboardActivityTile extends StatelessWidget {
  final DashboardActivityItem item;
  final bool isDark;

  const DashboardActivityTile({
    super.key,
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final (iconData, iconBg, iconColor) = _resolveActivityIcon(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGreyColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.date,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: item.isCredit
                  ? AppColors.greenColor
                  : const Color(0xFFFF4757),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, Color) _resolveActivityIcon(DashboardActivityItem item) {
    switch (item.type) {
      case DashboardActivityType.sent:
        return (
          Icons.arrow_outward_rounded,
          const Color(0xFFFFEBED).withValues(alpha: 0.12),
          const Color(0xFFFF4757),
        );
      case DashboardActivityType.received:
        return (
          Icons.call_received_rounded,
          const Color(0xFFE8F8F0).withValues(alpha: 0.12),
          AppColors.greenColor,
        );
      case DashboardActivityType.group:
        return (
          Iconsax.people_outline,
          AppColors.primaryColor.withValues(alpha: 0.12),
          AppColors.primaryColor,
        );
    }
  }
}
