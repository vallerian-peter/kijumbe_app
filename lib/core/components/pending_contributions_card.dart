import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../localization/app_locale.dart';

/// A global, reusable amber-themed card/banner for pending contributions and alerts.
/// Features high-contrast, accessible amber tones in both light and dark themes.
class PendingContributionsCard extends StatelessWidget {
  /// Number of pending contributions or actions (optional).
  final int? pendingCount;

  /// Custom title for the banner (defaults to localized "Pending Contributions").
  final String? title;

  /// Custom subtitle text. If null and [pendingCount] is provided, generates
  /// a clean localized message.
  final String? subtitle;

  /// Leading icon (defaults to [Icons.warning_amber_rounded]).
  final IconData leadingIcon;

  /// Optional custom trailing widget (defaults to right chevron arrow).
  final Widget? trailing;

  /// Optional callback invoked when tapping the card.
  final VoidCallback? onTap;

  /// Whether dark mode is active. If null, resolves from [Theme.of(context)].
  final bool? isDark;

  /// Border radius of the card (default 16.0).
  final double borderRadius;

  /// Inner padding (default horizontal 16, vertical 14).
  final EdgeInsetsGeometry padding;

  const PendingContributionsCard({
    super.key,
    this.pendingCount,
    this.title,
    this.subtitle,
    this.leadingIcon = Icons.warning_amber_rounded,
    this.trailing,
    this.onTap,
    this.isDark,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark = isDark ?? (theme.brightness == Brightness.dark);
    final l10n = context.l10n;
    final isSw = Localizations.localeOf(context).languageCode == 'sw';

    // Amber Palette Tokens tailored for maximum contrast and aesthetics
    final Color bgColor;
    final Color borderColor;
    final Color iconBgColor;
    final Color iconColor;
    final Color titleColor;
    final Color subtitleColor;
    final Color trailingColor;

    if (effectiveIsDark) {
      bgColor = const Color(0xFF261D0C);
      borderColor = const Color(0xFF784D12).withValues(alpha: 0.7);
      iconBgColor = const Color(0xFF3D270A);
      iconColor = const Color(0xFFFBBF24); // Amber 400
      titleColor = const Color(0xFFFDE68A); // Amber 200
      subtitleColor = const Color(0xFFFCD34D).withValues(alpha: 0.85); // Amber 300
      trailingColor = const Color(0xFFFBBF24);
    } else {
      bgColor = const Color(0xFFFFFBEB); // Amber 50
      borderColor = const Color(0xFFFDE68A); // Amber 200
      iconBgColor = const Color(0xFFFEF3C7); // Amber 100
      iconColor = const Color(0xFFD97706); // Amber 600
      titleColor = const Color(0xFF92400E); // Amber 800
      subtitleColor = const Color(0xFFB45309).withValues(alpha: 0.9); // Amber 700
      trailingColor = const Color(0xFFD97706);
    }

    // Resolve subtitle text
    final String resolvedSubtitle;
    if (subtitle != null) {
      resolvedSubtitle = subtitle!;
    } else if (pendingCount != null) {
      if (isSw) {
        resolvedSubtitle = pendingCount == 1
            ? 'Mwanachama 1 anapaswa kuchanga leo'
            : 'Wanachama $pendingCount wanapaswa kuchanga leo';
      } else {
        resolvedSubtitle = pendingCount == 1
            ? '1 member has a contribution due today'
            : '$pendingCount members have contributions due today';
      }
    } else {
      resolvedSubtitle = isSw
          ? 'Tafadhali kamilisha mchango wako kwa wakati'
          : 'Please complete your contribution on time';
    }

    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: effectiveIsDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(leadingIcon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? l10n.pendingContributions,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  resolvedSubtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing ??
              Icon(
                Iconsax.arrow_right_3_outline,
                size: 16,
                color: trailingColor,
              ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Backward-compatible alias for [PendingContributionsCard].
typedef PendingContributionsBanner = PendingContributionsCard;
