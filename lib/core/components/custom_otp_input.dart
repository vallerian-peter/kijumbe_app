import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../localization/app_locale.dart';
import '../utils/colors.dart';

/// A minimal, casual, and theme-adaptive OTP Pin Input component built with [Pinput].
/// Supports 6-digit verification, auto-focus, smooth transitions, and custom box styles.
class CustomOtpInput extends StatefulWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final String? errorText;
  final Color? fillColor;
  final Color? focusedFillColor;
  final Color? submittedFillColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? submittedBorderColor;
  final Color? errorBorderColor;
  final bool? isDark;
  final double width;
  final double height;
  final double borderRadius;

  const CustomOtpInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onCompleted,
    this.autofocus = true,
    this.errorText,
    this.fillColor,
    this.focusedFillColor,
    this.submittedFillColor,
    this.textColor,
    this.borderColor,
    this.focusedBorderColor,
    this.submittedBorderColor,
    this.errorBorderColor,
    this.isDark,
    this.width = 48.0,
    this.height = 56.0,
    this.borderRadius = 12.0,
  });

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  late final TextEditingController _pinController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _pinController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _pinController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIsDark =
        widget.isDark ?? (theme.brightness == Brightness.dark);

    final effectivePrimary = effectiveIsDark
        ? AppColors.darkModePrimaryColor
        : AppColors.appPrimaryColor;

    final effectiveFillColor = widget.fillColor ??
        (effectiveIsDark ? const Color(0xFF1E232A) : AppColors.appGreyWhite);
    final effectiveFocusedFillColor = widget.focusedFillColor ??
        (effectiveIsDark
            ? effectivePrimary.withValues(alpha: 0.10)
            : effectiveFillColor);
    final effectiveSubmittedFillColor = widget.submittedFillColor ??
        (effectiveIsDark
            ? effectivePrimary.withValues(alpha: 0.14)
            : effectivePrimary.withValues(alpha: 0.06));

    final effectiveTextColor = widget.textColor ??
        (effectiveIsDark ? Colors.white : Colors.black87);

    final effectiveBorderColor = widget.borderColor ??
        (effectiveIsDark ? Colors.white24 : Colors.grey[300]!);
    final effectiveFocusedBorder = (widget.focusedBorderColor == null ||
            (effectiveIsDark && widget.focusedBorderColor == AppColors.appPrimaryColor))
        ? effectivePrimary
        : widget.focusedBorderColor!;
    final effectiveSubmittedBorder = (widget.submittedBorderColor == null ||
            (effectiveIsDark && widget.submittedBorderColor == AppColors.appPrimaryColor))
        ? effectivePrimary.withValues(alpha: effectiveIsDark ? 0.75 : 0.6)
        : widget.submittedBorderColor!;
    final errorColor = theme.colorScheme.error;
    final effectiveErrorBorder = widget.errorBorderColor ?? errorColor;

    final defaultPinTheme = PinTheme(
      width: widget.width,
      height: widget.height,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: effectiveTextColor,
      ),
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: 1.2,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: effectiveFocusedFillColor,
        border: Border.all(
          color: effectiveFocusedBorder,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveFocusedBorder.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: effectiveSubmittedFillColor,
        border: Border.all(
          color: effectiveSubmittedBorder,
          width: 1.5,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: effectiveErrorBorder,
          width: 1.5,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pinput(
          length: widget.length,
          controller: _pinController,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          keyboardType: TextInputType.number,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          forceErrorState: widget.errorText != null,
          separatorBuilder: (index) => const SizedBox(width: 8),
          cursor: Container(
            width: 2,
            height: 24,
            decoration: BoxDecoration(
              color: effectivePrimary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          showCursor: true,
          onChanged: widget.onChanged,
          onCompleted: widget.onCompleted,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: errorColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Helper timer widget for OTP resend flow (e.g. "Resend OTP in 00:45")
class OtpResendTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onResend;
  final String? didntReceiveCodeText;
  final String? resendCodeInText;
  final String? resendOtpText;

  const OtpResendTimer({
    super.key,
    this.initialSeconds = 60,
    required this.onResend,
    this.didntReceiveCodeText,
    this.resendCodeInText,
    this.resendOtpText,
  });

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = widget.initialSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleResend() {
    widget.onResend();
    setState(() {
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpired = _remainingSeconds == 0;

    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    final didntReceive = widget.didntReceiveCodeText ?? context.l10n.didntReceiveCode;
    final resendIn = widget.resendCodeInText ?? context.l10n.resendCodeIn;
    final resendOtp = widget.resendOtpText ?? context.l10n.resendOtp;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isExpired ? '$didntReceive ' : '$resendIn ',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
        if (!isExpired)
          Text(
            '$minutes:$seconds',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkModePrimaryColor
                  : AppColors.appPrimaryColor,
            ),
          )
        else
          TextButton(
            onPressed: _handleResend,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: isDark
                  ? AppColors.darkModePrimaryColor
                  : AppColors.appPrimaryColor,
            ),
            child: Text(
              resendOtp,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

