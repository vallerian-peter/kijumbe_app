import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../../member/member.dart';

/// Interactive modal bottom sheet presenting 2 selectable registration cards:
/// 1. Kijumbe (Group Leader / Organizer)
/// 2. Member (Group Participant)
class RegistrationTypeBottomSheet extends StatelessWidget {
  const RegistrationTypeBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RegistrationTypeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Drag Handle
            Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header Title
            Text(
              l10n.selectRegistrationType,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: isDark ? Colors.white : AppColors.blackColor,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              l10n.selectRegistrationTypeSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey[600],
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),

            // 2 Boxes in a Row
            Row(
              children: [
                // Box 1: Kijumbe Registration (Leader)
                Expanded(
                  child: _RegistrationOptionCard(
                    icon: Icons.shield_outlined,
                    iconBgColor: isDark
                        ? AppColors.darkModePrimaryColor
                        : AppColors.appPrimaryColor,
                    title: l10n.kijumbeRegistration,
                    description: l10n.kijumbeRegistrationDesc,
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),

                // Box 2: Member Registration
                Expanded(
                  child: _RegistrationOptionCard(
                    icon: Icons.people_alt_outlined,
                    iconBgColor: AppColors.greenColor,
                    title: l10n.memberRegistration,
                    description: l10n.memberRegistrationDesc,
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MemberCreateAccountScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrationOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final bool isDark;
  final VoidCallback onTap;

  const _RegistrationOptionCard({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 195,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : AppColors.appGreyWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Pill
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconBgColor,
                size: 22,
              ),
            ),
            const Spacer(),

            // Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.blackColor,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),

            // Short Description
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white60 : Colors.grey[600],
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
