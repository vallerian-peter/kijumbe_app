import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../auth.dart';

/// Screen displayed right after Create Account where the user enters their
/// 6-digit phone OTP code to verify their mobile number before profile completion.
class CreateAccountOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onVerified;

  const CreateAccountOtpScreen({
    super.key,
    required this.phoneNumber,
    this.onVerified,
  });

  @override
  State<CreateAccountOtpScreen> createState() => _CreateAccountOtpScreenState();
}

class _CreateAccountOtpScreenState extends State<CreateAccountOtpScreen> {
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
      '${context.l10n.newCodeSentTo} ${widget.phoneNumber}',
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
      CustomToast.showSuccess(context, context.l10n.otpVerifiedSuccess);

      if (widget.onVerified != null) {
        widget.onVerified!();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
              initialPhone: widget.phoneNumber,
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
        leading: Navigator.canPop(context)
            ? Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: CustomBackButton(
                  onTap: () => Navigator.pop(context),
                ),
              )
            : null,
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

                    // Phone OTP Icon Pill
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phonelink_ring_rounded,
                        color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
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
                    const SizedBox(height: 36),

                    // 6-digit OTP Box Input
                    CustomOtpInput(
                      length: 6,
                      controller: _otpController,
                      autofocus: true,
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
                    const SizedBox(height: 32),

                    // Resend Timer
                    OtpResendTimer(
                      initialSeconds: 60,
                      onResend: _handleResend,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Verify Button
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
