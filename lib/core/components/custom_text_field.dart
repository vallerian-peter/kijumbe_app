import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import '../utils/colors.dart';

/// A professional, theme-aware text field with:
/// - Primary color borders on focus/selection
/// - Integrated validation & error message at the bottom
/// - Smart prefix & suffix icons (only rendered when present)
/// - Built-in password visibility toggle
/// - Clean label above the input
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.borderRadius = 14.0,
    this.fillColor,
    this.bgColor,
    this.isDark,
    this.textColor,
    this.labelColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.iconColor,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.contentPadding,
    this.inputFormatters,
    this.maxLength,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final double borderRadius;
  final Color? fillColor;
  final Color? bgColor;
  final bool? isDark;
  final Color? textColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? iconColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark =
        widget.isDark ?? (theme.brightness == Brightness.dark);

    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;

    // Theme-driven background fill
    final Color defaultFill = effectiveIsDark
        ? const Color(0xFF1E2226)
        : const Color(0xFFF9FAFB);

    final Color effectiveFill =
        widget.fillColor ?? widget.bgColor ?? defaultFill;

    // Theme-driven borders
    final Color defaultBorder = effectiveIsDark
        ? Colors.grey.shade800
        : const Color(0xFFE5E7EB);

    final Color unselectedBorder = widget.borderColor ?? defaultBorder;
    final Color effectiveFocusedBorder =
        widget.focusedBorderColor ?? primaryColor;

    // Labels & icons
    final Color defaultLabelColor = _isFocused
        ? effectiveFocusedBorder
        : (effectiveIsDark ? Colors.white70 : AppColors.darkGreyColor);

    final Color effectiveLabelColor = widget.labelColor ?? defaultLabelColor;

    final Color defaultIconColor = _isFocused
        ? effectiveFocusedBorder
        : (effectiveIsDark ? Colors.white54 : Colors.grey.shade500);

    final Color effectiveIconColor = widget.iconColor ?? defaultIconColor;

    // Input text & hint colors
    final Color effectiveTextColor = widget.textColor ??
        (effectiveIsDark ? Colors.white : AppColors.blackColor);

    final Color effectiveHintColor = widget.hintColor ??
        (effectiveIsDark ? Colors.white38 : Colors.grey.shade400);

    // Suffix resolution: explicit suffixIcon > password toggle > null
    Widget? effectiveSuffix;
    if (widget.suffixIcon != null) {
      effectiveSuffix = widget.suffixIcon;
    } else if (widget.isPassword) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscureText ? Bootstrap.eye_slash : Bootstrap.eye,
          size: 20,
          color: effectiveIconColor,
        ),
        splashRadius: 20,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top label (rendered only when provided)
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: effectiveLabelColor,
                  letterSpacing: -0.2,
                ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Form Field with full theme & validation support
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          buildCounter: widget.maxLength != null
              ? (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null
              : null,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          style: widget.style ??
              TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: effectiveTextColor,
              ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: effectiveFill,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: effectiveHintColor,
                ),
            errorText: widget.errorText,
            errorMaxLines: 2,
            errorStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: errorColor,
              height: 1.3,
            ),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),

            // Prefix Icon: only present when provided
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(color: effectiveIconColor, size: 20),
                    child: widget.prefixIcon!,
                  )
                : null,

            // Suffix Icon: only present when provided or password toggle active
            suffixIcon: effectiveSuffix,

            // Border styles
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: unselectedBorder, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: unselectedBorder, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  BorderSide(color: effectiveFocusedBorder, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: errorColor, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: errorColor, width: 1.8),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: effectiveIsDark ? Colors.white10 : Colors.grey.shade200,
                width: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

