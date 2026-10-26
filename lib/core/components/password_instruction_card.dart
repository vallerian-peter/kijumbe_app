import 'package:flutter/material.dart';
import '../localization/app_locale.dart';
import '../utils/colors.dart';
import 'custom_card.dart';

/// A single password requirement item row with animated check indicator.
class PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;
  final bool? isDark;

  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.isMet,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark = isDark ?? (theme.brightness == Brightness.dark);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isMet ? AppColors.greenColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isMet
                    ? AppColors.greenColor
                    : (effectiveIsDark ? Colors.white30 : Colors.grey.shade400),
                width: 1.5,
              ),
            ),
            child: isMet
                ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
                color: isMet
                    ? (effectiveIsDark ? Colors.white : AppColors.blackColor)
                    : (effectiveIsDark ? Colors.white54 : Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A global, reusable, theme-aware password instructions card component.
/// Shows title "Password must contain:" along with animated criteria items:
/// - Min characters (default 6 or 8)
/// - Uppercase letter
/// - Number
/// - Optional lowercase letter
/// - Optional special character
/// - Optional match confirmation (for confirm password fields)
/// - Optional custom items
class PasswordInstructionCard extends StatelessWidget {
  /// Custom title for the card (defaults to localized "Password must contain:").
  final String? title;

  /// Whether min character length requirement is met.
  final bool? hasMinLength;

  /// Whether uppercase letter requirement is met.
  final bool? hasUppercase;

  /// Whether number requirement is met.
  final bool? hasNumber;

  /// Whether lowercase letter requirement is met (optional).
  final bool? hasLowercase;

  /// Whether special character requirement is met (optional).
  final bool? hasSpecialChar;

  /// Whether passwords match (optional, used in reset/change password flows).
  final bool? passwordsMatch;

  /// Custom text for match requirement when matched.
  final String? passwordsMatchText;

  /// Custom text for match requirement when NOT matched.
  final String? passwordsDoNotMatchText;

  /// Optional raw password string - if provided without explicit boolean flags,
  /// automatically computes criteria:
  /// - length >= minLength (default 6)
  /// - contains uppercase
  /// - contains digit
  /// - contains special char (if requireSpecialChar is true)
  final String? password;

  /// Optional confirm password string to validate matching against [password].
  final String? confirmPassword;

  /// Minimum password length requirement (default 6).
  final int minLength;

  /// Whether lowercase requirement should be shown.
  final bool showLowercase;

  /// Whether special character requirement is enforced/shown.
  final bool showSpecialChar;

  /// Optional custom requirements to append.
  final List<PasswordRequirementItem>? customItems;

  /// Custom background color.
  final Color? bgColor;

  /// Custom border color.
  final Color? borderColor;

  /// Padding for the card.
  final EdgeInsetsGeometry padding;

  /// Custom dark mode override.
  final bool? isDark;

  const PasswordInstructionCard({
    super.key,
    this.title,
    this.hasMinLength,
    this.hasUppercase,
    this.hasNumber,
    this.hasLowercase,
    this.hasSpecialChar,
    this.passwordsMatch,
    this.passwordsMatchText,
    this.passwordsDoNotMatchText,
    this.password,
    this.confirmPassword,
    this.minLength = 6,
    this.showLowercase = false,
    this.showSpecialChar = false,
    this.customItems,
    this.bgColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(16.0),
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final effectiveIsDark = isDark ?? (theme.brightness == Brightness.dark);

    // Compute criteria if explicit flags not provided
    final rawPwd = password ?? '';
    final minMet = hasMinLength ?? (rawPwd.length >= minLength);
    final upperMet = hasUppercase ?? rawPwd.contains(RegExp(r'[A-Z]'));
    final lowerMet = hasLowercase ?? rawPwd.contains(RegExp(r'[a-z]'));
    final numberMet = hasNumber ?? rawPwd.contains(RegExp(r'[0-9]'));
    final specialMet = hasSpecialChar ??
        rawPwd.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    final bool? matchMet;
    if (passwordsMatch != null) {
      matchMet = passwordsMatch;
    } else if (confirmPassword != null) {
      matchMet = rawPwd.isNotEmpty && rawPwd == confirmPassword;
    } else {
      matchMet = null;
    }

    final effectiveBgColor = bgColor ??
        (effectiveIsDark
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : theme.colorScheme.primary.withValues(alpha: 0.08));

    final effectiveBorderColor = borderColor ??
        (effectiveIsDark
            ? theme.colorScheme.primary.withValues(alpha: 0.35)
            : theme.colorScheme.primary.withValues(alpha: 0.20));

    return CustomCard(
      padding: padding,
      borderRadius: 16.0,
      bgColor: effectiveBgColor,
      borderColor: effectiveBorderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? l10n.passwordMustContain,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: effectiveIsDark ? Colors.white : AppColors.blackColor,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          PasswordRequirementItem(
            text: l10n.passwordMinChars,
            isMet: minMet,
            isDark: effectiveIsDark,
          ),
          PasswordRequirementItem(
            text: l10n.passwordUppercase,
            isMet: upperMet,
            isDark: effectiveIsDark,
          ),
          if (showLowercase)
            PasswordRequirementItem(
              text: l10n.passwordLowercase,
              isMet: lowerMet,
              isDark: effectiveIsDark,
            ),
          PasswordRequirementItem(
            text: l10n.passwordNumber,
            isMet: numberMet,
            isDark: effectiveIsDark,
          ),
          if (showSpecialChar)
            PasswordRequirementItem(
              text: l10n.passwordSpecialChar,
              isMet: specialMet,
              isDark: effectiveIsDark,
            ),
          if (matchMet != null)
            PasswordRequirementItem(
              text: matchMet
                  ? (passwordsMatchText ?? l10n.passwordsMatch)
                  : (passwordsDoNotMatchText ?? l10n.passwordsDoNotMatch),
              isMet: matchMet,
              isDark: effectiveIsDark,
            ),
          if (customItems != null) ...customItems!,
        ],
      ),
    );
  }
}
