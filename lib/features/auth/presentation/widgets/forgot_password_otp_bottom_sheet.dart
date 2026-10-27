import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';

/// Entry point to display the OTP verification bottom sheet for Forgot Password.
/// Uses the unified [CustomBottomSheet] shell with pure content separation.
class ForgotPasswordOtpBottomSheet {
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
      child: ForgotPasswordOtpContent(phoneNumber: phoneNumber),
    );
  }
}

/// Pure content widget for OTP verification in Forgot Password flow.
/// Designed to be plugged into [CustomBottomSheet] or any container.
class ForgotPasswordOtpContent extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<bool>? onVerified;

  const ForgotPasswordOtpContent({
    super.key,
    required this.phoneNumber,
    this.onVerified,
  });

  @override
  State<ForgotPasswordOtpContent> createState() =>
      _ForgotPasswordOtpContentState();
}

class _ForgotPasswordOtpContentState extends State<ForgotPasswordOtpContent> {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Center Icon Badge
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.appPrimaryColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.phonelink_ring_rounded,
            color: AppColors.appPrimaryColor,
            size: 28,
          ),
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          l10n.otpVerificationTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.whiteColor,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle with target phone
        Text.rich(
          TextSpan(
            text: '${l10n.enterOtpSentTo}\n',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: widget.phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 28),

        // 6-digit OTP Pin Input
        CustomOtpInput(
          length: 6,
          controller: _otpController,
          autofocus: true,
          isDark: true,
          fillColor: const Color(0xFF1E2226),
          textColor: Colors.white,
          borderColor: Colors.white12,
          focusedBorderColor: AppColors.appPrimaryColor,
          onChanged: (pin) {
            setState(() {
              _currentOtp = pin;
            });
          },
          onCompleted: (pin) {
            setState(() {
              _currentOtp = pin;
            });
          },
        ),

        const SizedBox(height: 24),

        // Resend code timer row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _countdown > 0
                  ? '${l10n.resendCodeIn} ${_countdown}s'
                  : l10n.didntReceiveCode,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white60,
              ),
            ),
            if (_countdown == 0) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _handleResend,
                child: Text(
                  l10n.resendCode,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 28),

        // Verify CTA Button
        CustomButon(
          text: l10n.verifyOtp,
          height: 52,
          borderRadius: 26,
          gradient: AppColors.primaryTealGradient,
          onPressed: _currentOtp.trim().length == 6 ? _handleVerify : null,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
