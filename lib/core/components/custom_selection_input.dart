import 'package:flutter/material.dart';
import 'custom_checkbox_tile.dart';

/// Defines the visual selection control style.
enum InputType {
  /// Standard square checkbox with animated checkmark.
  checkbox,

  /// Circular radio button with animated inner indicator.
  radio,

  /// Compact animated toggle switch.
  switchToggle,
}

/// Backward compatibility alias for [InputType].
typedef SelectionInputType = InputType;

/// Backward compatibility alias for [CustomSelectionInput].
typedef CustomRememberMe = CustomSelectionInput;

/// A versatile selection component placing the selection indicator on the LEFT
/// and the value/label on the RIGHT.
///
/// Ideal for "Remember Me" controls, single checkboxes, radio lists,
/// terms agreement rows, or selectable settings items.
class CustomSelectionInput extends StatelessWidget {
  const CustomSelectionInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.inputType = InputType.checkbox,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.enabled = true,
    this.spacing = 10.0,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.textStyle,
    this.subtitleStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isCard = false,
    this.padding,
    this.borderRadius = 8.0,
    this.onTap,
  });

  /// Factory constructor specifically tailored for checkboxes.
  const CustomSelectionInput.checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.enabled = true,
    this.spacing = 10.0,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.textStyle,
    this.subtitleStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isCard = false,
    this.padding,
    this.borderRadius = 8.0,
    this.onTap,
  }) : inputType = InputType.checkbox;

  /// Factory constructor specifically tailored for radio buttons.
  const CustomSelectionInput.radio({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.enabled = true,
    this.spacing = 10.0,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.textStyle,
    this.subtitleStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isCard = false,
    this.padding,
    this.borderRadius = 8.0,
    this.onTap,
  }) : inputType = InputType.radio;

  /// Factory constructor specifically tailored for toggle switches.
  const CustomSelectionInput.switchToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.enabled = true,
    this.spacing = 10.0,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.textStyle,
    this.subtitleStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isCard = false,
    this.padding,
    this.borderRadius = 8.0,
    this.onTap,
  }) : inputType = InputType.switchToggle;

  /// Convenience constructor for "Remember Me" authentication controls.
  const CustomSelectionInput.rememberMe({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Remember me',
    this.labelWidget,
    this.enabled = true,
    this.spacing = 8.0,
    this.size = 19.0,
    this.activeColor,
    this.inactiveColor,
    this.checkColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 2.0),
    this.onTap,
  })  : inputType = InputType.checkbox,
        subtitle = null,
        subtitleWidget = null,
        subtitleStyle = null,
        trailing = null,
        mainAxisSize = MainAxisSize.min,
        crossAxisAlignment = CrossAxisAlignment.center,
        isCard = false,
        borderRadius = 6.0;

  /// The type of selection control (checkbox, radio, switch).
  final InputType inputType;

  /// Whether the selection input is currently checked/selected.
  final bool value;

  /// Callback triggered when the value toggles.
  final ValueChanged<bool>? onChanged;

  /// Optional primary text label on the right.
  final String? label;

  /// Optional custom widget for the value on the right (takes precedence over [label]).
  final Widget? labelWidget;

  /// Optional secondary text placed underneath the label.
  final String? subtitle;

  /// Optional custom secondary widget placed underneath the label.
  final Widget? subtitleWidget;

  /// Optional widget displayed at the end of the row.
  final Widget? trailing;

  /// Whether user interaction is enabled.
  final bool enabled;

  /// Gap between the left indicator and the right value.
  final double spacing;

  /// Diameter or dimension of the selection indicator.
  final double size;

  /// Color of the active indicator/border (defaults to theme primary color).
  final Color? activeColor;

  /// Color of the unselected border.
  final Color? inactiveColor;

  /// Checkmark or radio inner dot color (defaults to Colors.white).
  final Color? checkColor;

  /// Custom text style for the right label.
  final TextStyle? textStyle;

  /// Custom text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Layout axis size (defaults to [MainAxisSize.min] for inline compatibility).
  final MainAxisSize mainAxisSize;

  /// Alignment of indicator and text.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to style the component as an elevated/outlined card.
  final bool isCard;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// Border radius for the container or card.
  final double borderRadius;

  /// Optional additional tap callback.
  final VoidCallback? onTap;

  void _handleTap() {
    if (!enabled) return;
    onChanged?.call(!value);
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Widget indicator = _buildIndicator(context, isDark);
    final Widget content = _buildContent(context, isDark);

    Widget rowContent = Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: crossAxisAlignment == CrossAxisAlignment.start ? 2.0 : 0.0,
          ),
          child: indicator,
        ),
        SizedBox(width: spacing),
        if (mainAxisSize == MainAxisSize.max)
          Expanded(child: content)
        else
          Flexible(child: content),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );

    if (isCard) {
      final Color unselectedBg = isDark
          ? theme.colorScheme.surface.withValues(alpha: 0.6)
          : Colors.white;
      final Color selectedBg = isDark
          ? (activeColor ?? theme.colorScheme.primary).withValues(alpha: 0.12)
          : (activeColor ?? theme.colorScheme.primary).withValues(alpha: 0.05);

      final Color unselectedBorder = isDark
          ? Colors.grey.shade800
          : Colors.grey.shade200;
      final Color selectedBorder = activeColor ?? theme.colorScheme.primary;

      rowContent = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: value ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: value ? selectedBorder : unselectedBorder,
            width: value ? 1.6 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: rowContent,
      );
    } else if (padding != null) {
      rowContent = Padding(
        padding: padding!,
        child: rowContent,
      );
    }

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: enabled && onChanged != null ? _handleTap : null,
          splashColor: (activeColor ?? theme.colorScheme.primary).withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: rowContent,
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool isDark) {
    switch (inputType) {
      case InputType.checkbox:
        return CustomCheckbox(
          isSelected: value,
          size: size,
          borderRadius: (size * 0.28).clamp(4.0, 8.0),
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          checkColor: checkColor,
          onChanged: enabled && onChanged != null ? (_) => _handleTap() : null,
        );

      case InputType.radio:
        return CustomRadio(
          isSelected: value,
          size: size,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          dotColor: checkColor,
          onChanged: enabled && onChanged != null ? (_) => _handleTap() : null,
        );

      case InputType.switchToggle:
        return CustomMiniSwitch(
          isSelected: value,
          width: size * 1.7,
          height: size,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          thumbColor: checkColor,
          onChanged: enabled && onChanged != null ? (_) => _handleTap() : null,
        );
    }
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    if (labelWidget != null) {
      if (subtitle != null || subtitleWidget != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            labelWidget!,
            const SizedBox(height: 2),
            subtitleWidget ??
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ).merge(subtitleStyle),
                ),
          ],
        );
      }
      return labelWidget!;
    }

    if (label == null || label!.isEmpty) {
      return const SizedBox.shrink();
    }

    final TextStyle defaultLabelStyle = TextStyle(
      fontSize: 14,
      fontWeight: value ? FontWeight.w500 : FontWeight.w400,
      color: isDark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
    );

    final TextStyle defaultSubtitleStyle = TextStyle(
      fontSize: 12,
      color: isDark ? Colors.white38 : Colors.black45,
    );

    final Widget textWidget = Text(
      label!,
      style: defaultLabelStyle.merge(textStyle),
    );

    if (subtitle != null || subtitleWidget != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          const SizedBox(height: 2),
          subtitleWidget ??
              Text(
                subtitle!,
                style: defaultSubtitleStyle.merge(subtitleStyle),
              ),
        ],
      );
    }

    return textWidget;
  }
}

/// Standalone animated circular radio button with smooth scale transition.
class CustomRadio extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.dotColor,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveActive = activeColor ?? theme.colorScheme.primary;
    final effectiveInactive = inactiveColor ?? (isDark ? Colors.grey.shade600 : Colors.grey.shade400);

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isSelected) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? effectiveActive : effectiveInactive,
            width: 1.8,
          ),
        ),
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: isSelected ? (size * 0.5).clamp(6.0, 16.0) : 0.0,
          height: isSelected ? (size * 0.5).clamp(6.0, 16.0) : 0.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? (dotColor ?? effectiveActive) : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

/// Standalone animated mini toggle switch.
class CustomMiniSwitch extends StatelessWidget {
  const CustomMiniSwitch({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.width = 34.0,
    this.height = 20.0,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveActive = activeColor ?? theme.colorScheme.primary;
    final effectiveInactive = inactiveColor ?? (isDark ? Colors.grey.shade800 : Colors.grey.shade300);
    final effectiveThumb = thumbColor ?? Colors.white;

    final double thumbSize = height - 4.0;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isSelected) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: isSelected ? effectiveActive : effectiveInactive,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: effectiveThumb,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
