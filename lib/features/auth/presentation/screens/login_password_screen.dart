import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';
import 'package:kijumbe_app/features/kijumbe/kijumbe.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen where the user inputs their password after completing OTP verification.
/// Matches the full screen login page layout with Terms and Conditions checkbox
/// and Login action button at the bottom.
class LoginPasswordScreen extends StatefulWidget {
  final String phoneNumber;

  const LoginPasswordScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  bool _rememberMe = false;
  bool _termsAndCondition = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTermsAndConditions;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacyPolicy;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _openTermsAndConditions() async {
    final Uri uri = Uri.parse('https://kijumbe.com/terms');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Ignored or logged
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri uri = Uri.parse('https://kijumbe.com/privacy');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Ignored or logged
    }
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAndCondition) {
        CustomToast.showWarning(
          context,
          context.l10n.acceptTermsAndPrivacyWarning,
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const KijumbeHomeScreen(),
        ),
        (route) => false,
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
            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
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

                      // Subtitle with phone number
                      Text(
                        widget.phoneNumber.isNotEmpty
                            ? widget.phoneNumber
                            : l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontWeight: widget.phoneNumber.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.normal,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

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
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me
                          CustomSelectionInput.rememberMe(
                            value: _rememberMe,
                            label: l10n.rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val;
                              });
                            },
                          ),

                          // Forgot Password
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPassword(),
                              ),
                            ),
                            child: Text(
                              l10n.forgotPassword,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Bottom Actions Bar
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
                  CustomSelectionInput.checkbox(
                    value: _termsAndCondition,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    size: 19,
                    onChanged: (value) {
                      setState(() {
                        _termsAndCondition = value;
                      });
                    },
                    labelWidget: Text.rich(
                      TextSpan(
                        text: l10n.termsAgreementPrefix,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.termsAndConditions,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.primary,
                            ),
                            recognizer: _termsRecognizer,
                          ),
                          TextSpan(text: l10n.andAlsoAbideWithOur),
                          TextSpan(
                            text: l10n.privacyPolicy,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: theme.colorScheme.primary,
                            ),
                            recognizer: _privacyRecognizer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  CustomButon(
                    text: l10n.login,
                    height: 54,
                    borderRadius: 27,
                    onPressed: _termsAndCondition ? _onLogin : null,
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
