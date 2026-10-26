import 'package:flutter/material.dart';

/// A customizable checkbox and selectable tile with theme management.
/// When selected, the border and checkbox highlight using the theme's primary color.
class CustomCheckboxTile extends StatelessWidget {
  const CustomCheckboxTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    this.borderRadius = 16.0,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-responsive background and border colors
    final Color unselectedBg = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.6)
        : Colors.white;
    final Color selectedBg = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.15)
        : theme.colorScheme.primary.withValues(alpha: 0.06);

    final Color unselectedBorder = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    final Color selectedBorder = theme.colorScheme.primary;

    final Color titleColor = isSelected
        ? (isDark ? Colors.white : theme.colorScheme.primary)
        : (isDark ? Colors.white70 : theme.colorScheme.tertiary);

    final Color subtitleColor = isDark ? Colors.white38 : Colors.black45;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? selectedBg : unselectedBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected ? selectedBorder : unselectedBorder,
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: titleColor,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Custom Checkbox Indicator with theme management
                CustomCheckbox(
                  isSelected: isSelected,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Standalone animated checkbox with theme management.
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.size = 22.0,
    this.borderRadius = 6.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final double size;
  final double borderRadius;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? checkColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final unselectedBorder = inactiveColor ?? (isDark ? Colors.grey.shade600 : Colors.grey.shade400);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isSelected) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? effectiveActiveColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? effectiveActiveColor : unselectedBorder,
            width: 1.8,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check_rounded,
                size: (size * 0.72).clamp(12.0, 32.0),
                color: checkColor ?? Colors.white,
              )
            : null,
      ),
    );
  }
}
