import 'package:flutter/material.dart';

/// A reusable, theme-aware card container.
/// Defaults to a subtle primary-tinted background and border, but allows full customization of
/// [bgColor], [borderColor], [borderWidth], [borderRadius], [padding], and [child].
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.bgColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.width = double.infinity,
    this.height,
    this.onTap,
  });

  final Widget child;
  final Color? bgColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBgColor = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.15)
        : theme.colorScheme.primary.withValues(alpha: 0.08);

    final defaultBorderColor = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.35)
        : theme.colorScheme.primary.withValues(alpha: 0.25);

    final cardChild = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor ?? defaultBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? defaultBorderColor,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: cardChild,
        ),
      );
    }

    return cardChild;
  }
}
