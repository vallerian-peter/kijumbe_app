import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class PhoneOtpStep extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback? onOtpCompleted;

  const PhoneOtpStep({
    super.key,
    required this.phoneNumber,
    required this.onOtpChanged,
    this.onOtpCompleted,
  });

  @override
  State<PhoneOtpStep> createState() => _PhoneOtpStepState();
}

class _PhoneOtpStepState extends State<PhoneOtpStep> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleResend() {
    CustomToast.showSuccess(
      context,
      '${context.l10n.newCodeSentTo} ${widget.phoneNumber}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        // Phone OTP Icon Pill
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.phonelink_ring_rounded,
            color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),

        // Title
        Text(
          l10n.phoneVerificationTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.blackColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle with phone number
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.grey[600],
                height: 1.4,
              ),
              children: [
                TextSpan(text: '${l10n.enterOtpSentTo}\n'),
                TextSpan(
                  text: widget.phoneNumber.isNotEmpty
                      ? widget.phoneNumber
                      : '+255 712 345 678',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Minimal & casual 6-digit custom Pinput boxes
        CustomOtpInput(
          length: 6,
          controller: _otpController,
          autofocus: true,
          onChanged: (pin) {
            widget.onOtpChanged(pin);
          },
          onCompleted: (pin) {
            widget.onOtpChanged(pin);
            widget.onOtpCompleted?.call();
          },
        ),
        const SizedBox(height: 28),

        // Resend Timer
        OtpResendTimer(
          initialSeconds: 60,
          onResend: _handleResend,
        ),
      ],
    );
  }
}
