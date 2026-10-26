import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';

/// Screen allowing the user to enter their phone number to initiate login.
/// Once the phone number is provided and validated, the user continues to OTP
/// verification, followed by [LoginPasswordScreen].
class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

/// Backward compatibility alias for [LoginPhoneScreen].
typedef LoginScreen = LoginPhoneScreen;

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
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

  Future<void> _handleContinue() async {
    final l10n = context.l10n;

    if (!_isPhoneValid) {
      CustomToast.showWarning(context, l10n.phoneInvalid);
      return;
    }

    final displayPhone = _completePhone.isNotEmpty
        ? _completePhone
        : '+255 $_rawPhone';

    // Show success toast for OTP code dispatch
    CustomToast.showSuccess(
      context,
      '${l10n.verificationCodeSent} $displayPhone',
    );

    // Slide up the dedicated OTP verification bottom sheet
    final isVerified = await LoginOtpBottomSheet.show(
      context,
      phoneNumber: displayPhone,
    );

    // On successful OTP verification, navigate to the password screen
    if (isVerified == true && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPasswordScreen(
            phoneNumber: displayPhone,
          ),
        ),
      );
    }
  }

  void _onRegisterHere() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAccountScreen(),
      ),
    );
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
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // Top: Title
                    Text(
                      l10n.loginToYourAccount,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.blackColor,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Phone Number Input
                    CustomPhoneNumberField(
                      controller: _phoneNumberController,
                      label: l10n.mobilePhoneLabel,
                      autofocus: true,
                      onChanged: (phone) {
                        setState(() {
                          _rawPhone =
                              phone.number.replaceAll(RegExp(r'\D'), '');
                          _completePhone = phone.completeNumber;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Actions Container
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 14.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButon(
                    text: l10n.continueText,
                    height: 54,
                    borderRadius: 27,
                    onPressed: _isPhoneValid ? _handleContinue : null,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: _onRegisterHere,
                        child: Text(
                          l10n.registerHere,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
