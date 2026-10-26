import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/screens/create_group_screen.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class DashboardCreateGroupButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;

  const DashboardCreateGroupButton({
    super.key,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor;

    return GestureDetector(
      onTap: onTap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateGroupScreen(),
                ),
              ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? effectivePrimary.withValues(alpha: 0.16)
              : effectivePrimary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: effectivePrimary.withValues(alpha: isDark ? 0.45 : 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                color: effectivePrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n?.createNewGroup ?? 'Create new Group',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: effectivePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
