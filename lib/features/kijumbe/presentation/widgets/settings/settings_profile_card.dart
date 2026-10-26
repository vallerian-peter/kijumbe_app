import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/kijumbe_profile_screen.dart';

class SettingsProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final String role;
  final bool isDark;
  final VoidCallback? onTap;

  const SettingsProfileCard({
    super.key,
    required this.name,
    required this.phone,
    required this.role,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const KijumbeProfileScreen(),
                ),
              ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryTealGradient,
                      ),
                    ),
                    Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$role · $phone',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 25,
              color: Theme.of(context)
                  .colorScheme
                  .tertiary
                  .withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
