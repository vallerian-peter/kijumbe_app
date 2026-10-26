import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';

/// Entry point to display the OTP verification bottom sheet for Login flow.
/// Uses the unified [CustomBottomSheet] shell with pure content separation.
class LoginOtpBottomSheet {
  /// Opens the unified [CustomBottomSheet] containing the OTP verification content.
  /// Returns `true` if the OTP was verified successfully.
  static Future<bool?> show(
    BuildContext context, {
    required String phoneNumber,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomBottomSheet.show<bool>(
      context,
      bgColor: isDark ? AppColors.darkGreyColor : Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      showCloseButton: true,
      minHeightFactor: 0.5,
      maxHeightFactor: 0.5,
      child: LoginOtpContent(phoneNumber: phoneNumber),
    );
  }
}

/// Pure content widget for OTP verification in Login flow.
class LoginOtpContent extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<bool>? onVerified;

  const LoginOtpContent({
    super.key,
    required this.phoneNumber,
    this.onVerified,
  });

  @override
  State<LoginOtpContent> createState() => _LoginOtpContentState();
}

class _LoginOtpContentState extends State<LoginOtpContent> {
  final TextEditingController _otpController = TextEditingController();
  String _currentOtp = '';
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _countdown = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _handleResend() {
    if (_countdown > 0) return;
    _startCountdown();
    final l10n = context.l10n;
    CustomToast.showSuccess(
      context,
      '${l10n.newCodeSentTo} ${widget.phoneNumber}',
    );
  }

  void _handleVerify() {
    final l10n = context.l10n;
    if (_currentOtp.trim().length != 6) {
      CustomToast.showWarning(context, l10n.otpRequired);
      return;
    }

    // Show success toast on verification
    CustomToast.showSuccess(context, l10n.otpVerifiedSuccess);

    widget.onVerified?.call(true);

    // Dismiss bottom sheet with success result
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Center Icon Badge
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: effectivePrimary.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.phonelink_ring_rounded,
            color: effectivePrimary,
            size: 26,
          ),
        ),

        const SizedBox(height: 12),

        // Title
        Text(
          l10n.otpVerificationTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 6),

        // Subtitle with target phone
        Text.rich(
          TextSpan(
            text: '${l10n.enterOtpSentTo}\n',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.black54,
              height: 1.35,
            ),
            children: [
              TextSpan(
                text: widget.phoneNumber,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // 6-digit OTP Pin Input
        CustomOtpInput(
          length: 6,
          controller: _otpController,
          autofocus: false,
          isDark: isDark,
          fillColor: isDark ? const Color(0xFF1E2226) : const Color(0xFFF3F4F6),
          textColor: isDark ? Colors.white : Colors.black87,
          borderColor: isDark ? Colors.white12 : Colors.grey.shade300,
          focusedBorderColor: effectivePrimary,
          onChanged: (pin) {
            setState(() {
              _currentOtp = pin;
            });
          },
          onCompleted: (pin) {
            setState(() {
              _currentOtp = pin;
            });
            _handleVerify();
          },
        ),

        const SizedBox(height: 16),

        // Resend code timer row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdown > 0
                  ? '${l10n.resendCodeIn} ${_countdown}s'
                  : l10n.didntReceiveCode,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            if (_countdown == 0) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _handleResend,
                child: Text(
                  l10n.resendOtp,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: effectivePrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
