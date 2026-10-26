import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../member.dart';

/// Screen for Member phone OTP code verification
class MemberOtpScreen extends StatefulWidget {
  final MemberProfileData profileData;
  final VoidCallback? onVerified;

  const MemberOtpScreen({
    super.key,
    required this.profileData,
    this.onVerified,
  });

  @override
  State<MemberOtpScreen> createState() => _MemberOtpScreenState();
}

class _MemberOtpScreenState extends State<MemberOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _currentOtp = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleResend() {
    CustomToast.showSuccess(
      context,
      '${context.l10n.newCodeSentTo} ${widget.profileData.displayPhone}',
    );
  }

  void _verifyOtp() {
    if (_currentOtp.trim().length != 6) {
      CustomToast.showWarning(context, context.l10n.otpRequired);
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      widget.profileData.isPhoneVerified = true;
      CustomToast.showSuccess(context, context.l10n.otpVerifiedSuccess);

      if (widget.onVerified != null) {
        widget.onVerified!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MemberCompleteProfileScreen(
              profileData: widget.profileData,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CustomBackButton(
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    // Phone Icon Badge
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phonelink_ring_rounded,
                        color: AppColors.greenColor,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      l10n.phoneVerificationTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.blackColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle with highlighted phone number
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                            height: 1.45,
                          ),
                          children: [
                            TextSpan(text: '${l10n.enterOtpSentTo}\n'),
                            TextSpan(
                              text: widget.profileData.displayPhone.isNotEmpty
                                  ? widget.profileData.displayPhone
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
                    const SizedBox(height: 36),

                    // 6-digit OTP Box Input
                    CustomOtpInput(
                      length: 6,
                      onCompleted: (val) {
                        setState(() => _currentOtp = val);
                        _verifyOtp();
                      },
                      onChanged: (val) {
                        setState(() => _currentOtp = val);
                      },
                    ),
                    const SizedBox(height: 28),

                    // Resend Timer
                    OtpResendTimer(
                      initialSeconds: 30,
                      onResend: _handleResend,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              child: CustomButon(
                text: l10n.verifyAndContinue,
                height: 54,
                borderRadius: 27,
                isLoading: _isSubmitting,
                onPressed: _currentOtp.length == 6 ? _verifyOtp : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
