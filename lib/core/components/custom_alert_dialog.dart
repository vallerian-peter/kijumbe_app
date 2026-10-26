import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'custom_button.dart';

enum AlertType {
  success,
  warning,
  danger,
  info;

  static const AlertType error = AlertType.danger;
}

/// Helper to get color and icon based on AlertType
extension AlertTypeDetails on AlertType {
  Color get color {
    switch (this) {
      case AlertType.success:
        return const Color(0xFF22C55E);
      case AlertType.warning:
        return const Color(0xFFF59E0B);
      case AlertType.danger:
        return const Color(0xFFEF4444);
      case AlertType.info:
        return AppColors.appPrimaryColor;
    }
  }

  Color colorFor(bool isDark) {
    if (this == AlertType.info && isDark) {
      return AppColors.darkModePrimaryColor;
    }
    return color;
  }

  IconData get icon {
    switch (this) {
      case AlertType.success:
        return Icons.check_circle_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.danger:
        return Icons.error_outline_rounded;
      case AlertType.info:
        return Icons.info_outline_rounded;
    }
  }
}

/// An embedded in-page alert container / banner with 4 types [success, warning, danger, info]
class CustomAlertBox extends StatelessWidget {
  final AlertType type;
  final String? title;
  final String message;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const CustomAlertBox({
    super.key,
    this.type = AlertType.info,
    this.title,
    required this.message,
    this.trailing,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = type.colorFor(isDark);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(type.icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : color,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Themed modal confirmation alert dialog
class ConfirmationAlertDialog extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool showCancel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationAlertDialog({
    super.key,
    this.type = AlertType.warning,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.showCancel = true,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    AlertType type = AlertType.warning,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool showCancel = true,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ConfirmationAlertDialog(
        type: type,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        showCancel: showCancel,
        onConfirm: () {
          Navigator.of(ctx).pop(true);
          onConfirm?.call();
        },
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = type.colorFor(isDark);

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E232A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Pill
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, color: color, size: 30),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            if (showCancel)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: confirmText,
                      height: 48,
                      borderRadius: 12,
                      bgColor: type == AlertType.danger ? Colors.red : null,
                      onPressed: onConfirm,
                    ),
                  ),
                ],
              )
            else
              CustomButton(
                text: confirmText,
                height: 48,
                borderRadius: 12,
                bgColor: type == AlertType.danger ? Colors.red : null,
                onPressed: onConfirm,
              ),
          ],
        ),
      ),
    );
  }
}

/// A versatile custom dialog supporting 1 or 2 buttons, title, subtitle,
/// optional header icon, and arbitrary content (e.g. form fields).
class CustomActionDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final IconData? icon;
  final Widget? headerIcon;
  final Color? iconColor;
  final Widget? content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final Color? primaryButtonColor;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final bool isDismissible;

  const CustomActionDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.titleWidget,
    this.subtitleWidget,
    this.icon,
    this.headerIcon,
    this.iconColor,
    this.content,
    this.primaryButtonText = 'OK',
    this.onPrimaryPressed,
    this.primaryButtonColor,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.isDismissible = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? titleWidget,
    Widget? subtitleWidget,
    IconData? icon,
    Widget? headerIcon,
    Color? iconColor,
    Widget? content,
    String primaryButtonText = 'OK',
    VoidCallback? onPrimaryPressed,
    Color? primaryButtonColor,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => CustomActionDialog(
        title: title,
        subtitle: subtitle,
        titleWidget: titleWidget,
        subtitleWidget: subtitleWidget,
        icon: icon,
        headerIcon: headerIcon,
        iconColor: iconColor,
        content: content,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        primaryButtonColor: primaryButtonColor,
        secondaryButtonText: secondaryButtonText,
        onSecondaryPressed: onSecondaryPressed,
        isDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = primaryButtonColor ?? AppColors.primaryColor;
    final effectiveIconColor = iconColor ?? primaryColor;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF23272E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional Header Icon
            if (headerIcon != null || icon != null) ...[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: headerIcon ??
                    Icon(
                      icon,
                      color: effectiveIconColor,
                      size: 22,
                    ),
              ),
              const SizedBox(height: 14),
            ],

            // Title
            titleWidget ??
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.blackColor,
                    letterSpacing: -0.3,
                  ),
                ),

            // Subtitle
            if (subtitleWidget != null) ...[
              const SizedBox(height: 6),
              subtitleWidget!,
            ] else if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
            ],

            // Custom Content (e.g. Form Fields)
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],

            const SizedBox(height: 22),

            // Buttons: 2 buttons if secondaryButtonText is provided, otherwise 1 button
            if (secondaryButtonText != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryPressed ??
                          () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        secondaryButtonText!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: primaryButtonText,
                      height: 46,
                      borderRadius: 12,
                      bgColor: primaryColor,
                      onPressed: onPrimaryPressed,
                    ),
                  ),
                ],
              )
            else
              CustomButton(
                text: primaryButtonText,
                height: 46,
                borderRadius: 12,
                bgColor: primaryColor,
                onPressed: onPrimaryPressed ??
                    () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

