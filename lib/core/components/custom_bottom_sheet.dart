import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// A universal, theme-adaptive modal bottom sheet container for the entire app.
///
/// Handles consistent layout:
/// - Drag handle pill
/// - Rounded top corners
/// - Background color (adaptive or custom, e.g. [AppColors.darkGreyColor])
/// - Optional header (leading icon, title, subtitle, close button)
/// - Keyboard insets ([MediaQuery.viewInsets.bottom]) and scrollability
class CustomBottomSheet extends StatelessWidget {
  /// The body content to display inside the bottom sheet.
  final Widget child;

  /// Optional title displayed in the header.
  final String? title;

  /// Optional custom widget for title.
  final Widget? titleWidget;

  /// Optional subtitle displayed under the title.
  final String? subtitle;

  /// Optional custom subtitle widget.
  final Widget? subtitleWidget;

  /// Optional icon badge displayed above or alongside the title.
  final Widget? leadingIcon;

  /// Whether to display the top drag handle pill.
  final bool showDragHandle;

  /// Whether to show the top-right close button.
  final bool showCloseButton;

  /// Background color of the sheet container.
  /// If null, adapts to current theme surface.
  final Color? bgColor;

  /// Border radius of the top edges (defaults to 28.0).
  final double borderRadius;

  /// Inner padding around the content (defaults to 24 horizontal, 12 vertical).
  final EdgeInsetsGeometry? padding;

  /// Maximum height constraint as a fraction of screen height (defaults to 0.88).
  final double maxHeightFactor;

  /// Optional minimum height constraint as a fraction of screen height (e.g. 0.5 for deviceHeight / 2).
  final double? minHeightFactor;

  /// Optional callback invoked when the close button is pressed.
  final VoidCallback? onClose;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.leadingIcon,
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.bgColor,
    this.borderRadius = 28.0,
    this.padding,
    this.maxHeightFactor = 0.88,
    this.minHeightFactor,
    this.onClose,
  });

  /// Static helper to display this modal bottom sheet across the app.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    Widget? titleWidget,
    String? subtitle,
    Widget? subtitleWidget,
    Widget? leadingIcon,
    bool showDragHandle = true,
    bool showCloseButton = true,
    Color? bgColor,
    double borderRadius = 28.0,
    EdgeInsetsGeometry? padding,
    double maxHeightFactor = 0.88,
    double? minHeightFactor,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomBottomSheet(
        title: title,
        titleWidget: titleWidget,
        subtitle: subtitle,
        subtitleWidget: subtitleWidget,
        leadingIcon: leadingIcon,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        bgColor: bgColor,
        borderRadius: borderRadius,
        padding: padding,
        maxHeightFactor: maxHeightFactor,
        minHeightFactor: minHeightFactor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    final Color effectiveBgColor = bgColor ??
        (isDark ? const Color(0xFF1E2226) : theme.colorScheme.surface);

    final bool isDarkBackground =
        effectiveBgColor == AppColors.darkGreyColor ||
        effectiveBgColor == AppColors.blackColor ||
        effectiveBgColor.computeLuminance() < 0.2;

    final Color titleColor =
        isDarkBackground ? Colors.white : (isDark ? Colors.white : Colors.black87);
    final Color subtitleColor =
        isDarkBackground ? Colors.white60 : (isDark ? Colors.white60 : Colors.black54);
    final Color closeIconColor =
        isDarkBackground ? Colors.white54 : (isDark ? Colors.white54 : Colors.black45);

    final bool hasHeader = title != null ||
        titleWidget != null ||
        subtitle != null ||
        subtitleWidget != null ||
        leadingIcon != null ||
        showCloseButton;

    final double minHeight = (minHeightFactor != null && bottomInset == 0)
        ? screenHeight * minHeightFactor!
        : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: screenHeight * maxHeightFactor,
        ),
        padding: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Top Drag Handle Pill
              if (showDragHandle) ...[
                Center(
                  child: Container(
                    width: 44,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: isDarkBackground ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // 2. Top Header Row (Leading icon, titles, and close button)
              if (hasHeader) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40), // Left spacer to balance close button
                    if (leadingIcon != null)
                      Expanded(
                        child: Center(child: leadingIcon!),
                      )
                    else
                      const Spacer(),
                    if (showCloseButton)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.close_rounded, color: closeIconColor),
                        onPressed: onClose ?? () => Navigator.of(context).pop(),
                      )
                    else
                      const SizedBox(width: 40),
                  ],
                ),

                if (titleWidget != null) ...[
                  const SizedBox(height: 8),
                  titleWidget!,
                ] else if (title != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],

                if (subtitleWidget != null) ...[
                  const SizedBox(height: 6),
                  subtitleWidget!,
                ] else if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],

              // 3. Main Child Content
              child,
            ],
          ),
        ),
      ),
    ),
  );
}
}
