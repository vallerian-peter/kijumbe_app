import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isDark;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.blackColor,
            letterSpacing: -0.3,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel ?? (l10n?.viewAll ?? 'View all'),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkModePrimaryColor
                    : AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
