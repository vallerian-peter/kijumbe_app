import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:kijumbe_app/helpers/helpers.dart';
import '../utils/colors.dart';

/// A reusable, theme-adaptive and constant-dark friendly Phone Number Input field
/// powered by [IntlPhoneField] with country flag, dial code dropdown, and
/// 3-digit phone grouping formatting (`712 345 678`).
class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String initialCountryCode;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<Country>? onCountryChanged;
  final String? label;
  final String hintText;
  final bool? isDark;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final bool enabled;
  final bool autofocus;
  final int maxDigits;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  const CustomPhoneNumberField({
    super.key,
    this.controller,
    this.initialValue,
    this.initialCountryCode = 'TZ',
    this.onChanged,
    this.onCountryChanged,
    this.label,
    this.hintText = '712 345 678',
    this.isDark,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 14.0,
    this.enabled = true,
    this.autofocus = false,
    this.maxDigits = 9,
    this.contentPadding,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark = isDark ?? (theme.brightness == Brightness.dark);

    final effectiveFillColor = fillColor ??
        (effectiveIsDark ? const Color(0xFF1F2428) : const Color(0xFFF9FAFB));
    final effectiveTextColor = textColor ??
        (effectiveIsDark ? Colors.white : Colors.black87);
    final effectiveHintColor = hintColor ??
        (effectiveIsDark ? Colors.white38 : Colors.grey.shade400);
    final effectiveBorderColor = borderColor ??
        (effectiveIsDark ? Colors.grey.shade800 : const Color(0xFFE5E7EB));
    final effectiveFocusedBorder = focusedBorderColor ??
        (effectiveIsDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor);
    final errorColor = theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: effectiveIsDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        IntlPhoneField(
          controller: controller,
          initialValue: initialValue,
          initialCountryCode: initialCountryCode,
          disableLengthCheck: true,
          enabled: enabled,
          autofocus: autofocus,
          cursorColor: effectiveIsDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
          dropdownIconPosition: IconPosition.trailing,
          flagsButtonPadding: const EdgeInsets.only(left: 12),
          showCountryFlag: true,
          dropdownTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: effectiveTextColor,
          ),
          dropdownIcon: Icon(
            Icons.arrow_drop_down_rounded,
            color: effectiveIsDark ? Colors.white70 : Colors.black54,
          ),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: effectiveTextColor,
          ),
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            counterText: '',
            fillColor: effectiveFillColor,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: effectiveHintColor,
            ),
            errorText: errorText,
            errorMaxLines: 2,
            errorStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: errorColor,
              height: 1.3,
            ),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: effectiveBorderColor,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: effectiveBorderColor,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: effectiveFocusedBorder,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: errorColor,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: errorColor,
                width: 1.8,
              ),
            ),
          ),
          inputFormatters: [
            PhoneNumberGroupingFormatter(maxDigits: maxDigits),
          ],
          onChanged: onChanged,
          onCountryChanged: onCountryChanged,
        ),
      ],
    );
  }
}
