import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';

/// Screen allowing the user to initiate a password reset by providing their
/// registered mobile phone number.
///
/// Designed with a constant dark black background ([AppColors.blackColor])
/// independent of system theme mode.
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

/// Backward compatibility alias for [ForgotPassword].
typedef ForgotPasswordScreen = ForgotPassword;

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _phoneNumberController;
  String _rawPhone = '';
  String _completePhone = '';

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid => _rawPhone.length == 9;

  Future<void> _handleSendOtp() async {
    final l10n = context.l10n;

    if (!_isPhoneValid) {
      CustomToast.showWarning(context, l10n.phoneInvalid);
      return;
    }

    final displayPhone = _completePhone.isNotEmpty
        ? _completePhone
        : '+255 $_rawPhone';

    // Show success toast for OTP sending
    CustomToast.showSuccess(
      context,
      '${l10n.verificationCodeSent} $displayPhone',
    );

    // Slide up the dedicated OTP verification bottom sheet
    final isVerified = await ForgotPasswordOtpBottomSheet.show(
      context,
      phoneNumber: displayPhone,
    );

    // If verified successfully, navigate to the full Reset Password page
    if (isVerified == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            phoneNumber: displayPhone,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CustomBackButton(
            iconColor: AppColors.whiteColor,
            bgColor: Colors.white.withValues(alpha: 0.08),
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          l10n.forgotPasswordTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle / Instruction
                    Text(
                      l10n.forgotPasswordInstruction,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.white70,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Dedicated Phone Number Input Field
                    CustomPhoneNumberField(
                      controller: _phoneNumberController,
                      isDark: true,
                      fillColor: const Color(0xFF1E2226),
                      textColor: Colors.white,
                      hintColor: Colors.white38,
                      borderColor: Colors.grey.shade800,
                      focusedBorderColor: AppColors.appPrimaryColor,
                      label: l10n.mobilePhoneLabel,
                      onChanged: (phone) {
                        setState(() {
                          _rawPhone = phone.number.replaceAll(RegExp(r'\D'), '');
                          _completePhone = phone.completeNumber;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Floating Bottom Submit Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: const BoxDecoration(
                color: AppColors.blackColor,
              ),
              child: CustomButon(
                text: l10n.sendOtp,
                height: 54,
                borderRadius: 27,
                onPressed: _isPhoneValid ? _handleSendOtp : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
