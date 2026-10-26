import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomButon extends StatelessWidget {
  const CustomButon({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor,
    this.gradient,
    this.textColor,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.prefixIcon,
    this.suffixIcon,
    this.icon, // Backwards-compatible alias for prefixIcon
    this.iconSpacing = 8.0,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  /// Factory constructor for quickly building gradient buttons with a custom gradient
  const CustomButon.gradient({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.iconSpacing = 8.0,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1.0,
  })  : isOutlined = false,
        bgColor = null;

  /// Factory constructor for quickly building outlined buttons
  const CustomButon.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = Colors.transparent,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.iconSpacing = 8.0,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1.0,
  })  : isOutlined = true,
        gradient = null;

  final String text;
  final VoidCallback? onPressed;
  final Color? bgColor;
  final Gradient? gradient;
  final Color? textColor;
  final bool isOutlined;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? icon;
  final double iconSpacing;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultPrimary = theme.colorScheme.primary;

    // Resolve gradient vs solid vs outline:
    // 1. Outlined buttons NEVER have a gradient and default to transparent background.
    // 2. If a gradient is explicitly provided, use it.
    // 3. If a solid bgColor is explicitly provided, use solid color without gradient.
    // 4. Default filled button: automatically apply the dynamic shine primary gradient adapting to theme brightness.
    final bool hasGradient;
    final Gradient? effectiveGradient;

    if (isOutlined) {
      hasGradient = false;
      effectiveGradient = null;
    } else if (gradient != null) {
      hasGradient = true;
      effectiveGradient = gradient;
    } else if (bgColor != null) {
      hasGradient = false;
      effectiveGradient = null;
    } else {
      hasGradient = true;
      effectiveGradient = AppColors.primaryButtonGradientFor(isDark);
    }

    final effectiveBgColor = hasGradient
        ? Colors.transparent
        : (bgColor ?? (isOutlined ? Colors.transparent : defaultPrimary));

    final effectiveTextColor = textColor ??
        (isOutlined ? (borderColor ?? defaultPrimary) : Colors.white);

    final effectivePrefix = prefixIcon ?? icon;

    final BorderSide borderSide;
    if (isOutlined) {
      borderSide = BorderSide(
        color: borderColor ?? (textColor ?? defaultPrimary),
        width: borderWidth,
      );
    } else if (borderColor != null) {
      borderSide = BorderSide(
        color: borderColor!,
        width: borderWidth,
      );
    } else {
      borderSide = BorderSide.none;
    }

    final buttonChild = isLoading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          )
        : IconTheme(
            data: IconThemeData(
              color: effectiveTextColor,
              size: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (effectivePrefix != null) ...[
                  effectivePrefix,
                  SizedBox(width: iconSpacing),
                ],
                Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: effectiveTextColor,
                      ),
                ),
                if (suffixIcon != null) ...[
                  SizedBox(width: iconSpacing),
                  suffixIcon!,
                ],
              ],
            ),
          );

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveTextColor,
        shadowColor: hasGradient ? Colors.transparent : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide,
        ),
        elevation: 0,
      ),
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );

    if (hasGradient && effectiveGradient != null) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: (isDark
                      ? AppColors.darkModePrimaryColor
                      : AppColors.appPrimaryDarkColor)
                  .withValues(alpha: isDark ? 0.18 : 0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: button,
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: button,
    );
  }
}

/// Alias with standard spelling for convenience across the codebase.
typedef CustomButton = CustomButon;

