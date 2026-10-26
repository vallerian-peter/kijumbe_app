import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_group_detail_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class GroupMemberCard extends StatelessWidget {
  final MemberData member;
  final bool isDark;
  final VoidCallback? onRemind;

  const GroupMemberCard({
    super.key,
    required this.member,
    required this.isDark,
    this.onRemind,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;

    final effectivePrimary =
        isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Order badge (#1, #2...)
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFEEF2F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${member.payoutOrder}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : const Color(0xFF5A6A80),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name & Phone (Avatar Initial removed as requested)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (member.isKijumbe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: effectivePrimary.withValues(alpha: isDark ? 0.22 : 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Kijumbe',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: effectivePrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  member.phone,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? Colors.white54 : const Color(0xFF7A8A9E),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status / Action (Paid / Remind / Unpaid)
          if (member.hasPaid)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    color: AppColors.greenColor,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n?.paid ?? 'Paid',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenColor,
                    ),
                  ),
                ],
              ),
            )
          else if (onRemind != null)
            GestureDetector(
              onTap: onRemind,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9671).withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.notification_outline,
                      color: Color(0xFFFF9671),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n?.remind ?? 'Remind',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF9671),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9671).withValues(alpha: isDark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFFFF9671),
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n?.unpaid ?? 'Unpaid',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF9671),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

  }
}
