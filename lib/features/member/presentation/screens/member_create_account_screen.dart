import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../member.dart';

/// Screen for Member registration: Phone Number + Password
class MemberCreateAccountScreen extends StatefulWidget {
  const MemberCreateAccountScreen({super.key});

  @override
  State<MemberCreateAccountScreen> createState() => _MemberCreateAccountScreenState();
}

class _MemberCreateAccountScreenState extends State<MemberCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final MemberProfileData _data = MemberProfileData();

  final TextEditingController _passwordController = TextEditingController();

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswordCriteria);
  }

  void _validatePasswordCriteria() {
    final text = _passwordController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasUppercase = text.contains(RegExp(r'[A-Z]'));
      _hasNumber = text.contains(RegExp(r'[0-9]'));
    });
  }

  bool get _isPasswordValid => _hasMinLength && _hasUppercase && _hasNumber;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final rawPhone = _data.phone.replaceAll(RegExp(r'\D'), '');
    if (rawPhone.length != 9) {
      CustomToast.showWarning(context, context.l10n.phoneInvalid);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_isPasswordValid) {
      CustomToast.showWarning(context, context.l10n.passwordInvalid);
      return;
    }

    _data.password = _passwordController.text;

    final isVerified = await LoginOtpBottomSheet.show(
      context,
      phoneNumber: _data.displayPhone,
    );

    if (isVerified == true && mounted) {
      _data.isPhoneVerified = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MemberCompleteProfileScreen(
            profileData: _data,
          ),
        ),
      );
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        l10n.createAccountTitle,
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
                        l10n.createAccountSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white60 : Colors.black54,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Phone Number Field
                      CustomPhoneNumberField(
                        initialValue: _data.phone,
                        onChanged: (phone) {
                          _data.phone = phone.number;
                          _data.countryCode = phone.countryCode;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        hintText: l10n.createStrongPassword,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.passwordRequired;
                          }
                          if (!_isPasswordValid) {
                            return l10n.passwordInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Requirements Card
                      PasswordInstructionCard(
                        hasMinLength: _hasMinLength,
                        hasUppercase: _hasUppercase,
                        hasNumber: _hasNumber,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Continue Action
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
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
                    onPressed: _onContinue,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPhoneScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.loginHere,
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

