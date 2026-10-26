import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/helpers/helpers.dart';
import 'complete_profile_screen.dart';
import 'create_account_otp_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  String _rawPhone = '';
  String _countryCode = '+255';
  String _completePhone = '';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    super.dispose();
  }

  // Centralized password validation rules via ValidatorHelper
  bool get _hasMinLength =>
      ValidatorHelper.hasMinLength(_passwordController.text);
  bool get _hasUppercase =>
      ValidatorHelper.hasUppercase(_passwordController.text);
  bool get _hasNumber =>
      ValidatorHelper.hasNumber(_passwordController.text);

  bool get _isPasswordValid =>
      ValidatorHelper.isStrongPassword(_passwordController.text);

  bool get _isPhoneValid => _rawPhone.length == 9;

  void _onContinue() {
    final l10n = context.l10n;
    if (!_isPhoneValid) {
      CustomToast.showWarning(context, l10n.phoneInvalid);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final displayPhone = _completePhone.isNotEmpty
        ? _completePhone
        : '$_countryCode $_rawPhone';

    CustomToast.showSuccess(
      context,
      '${l10n.verificationCodeSent} $displayPhone',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAccountOtpScreen(
          phoneNumber: displayPhone,
          onVerified: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CompleteProfileScreen(
                  initialPhone: displayPhone,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLoginHere() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Top: Title
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
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Phone Number Field
                      CustomPhoneNumberField(
                        controller: _phoneController,
                        label: l10n.mobilePhoneLabel,
                        autofocus: false,
                        onChanged: (phone) {
                          setState(() {
                            _rawPhone =
                                phone.number.replaceAll(RegExp(r'\D'), '');
                            _countryCode = phone.countryCode;
                            _completePhone = phone.completeNumber;
                          });
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

                      // Instructions Card using CustomCard
                      CustomCard(
                        bgColor: isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderColor: isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.35)
                            : theme.colorScheme.primary.withValues(alpha: 0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.passwordMustContain,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.blackColor,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            PasswordRequirementItem(
                              text: l10n.passwordMinChars,
                              isMet: _hasMinLength,
                              isDark: isDark,
                            ),
                            PasswordRequirementItem(
                              text: l10n.passwordUppercase,
                              isMet: _hasUppercase,
                              isDark: isDark,
                            ),
                            PasswordRequirementItem(
                              text: l10n.passwordNumber,
                              isMet: _hasNumber,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButon(
                    text: l10n.continueText,
                    height: 54,
                    borderRadius: 27,
                    gradient: AppColors.primaryBlueGradient,
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
                        onTap: _onLoginHere,
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

/// Dynamic password requirement item that animates when requirement is fulfilled
class PasswordRequirementItem extends StatelessWidget {
  const PasswordRequirementItem({
    super.key,
    required this.text,
    required this.isMet,
    required this.isDark,
  });

  final String text;
  final bool isMet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isMet ? AppColors.greenColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isMet
                    ? AppColors.greenColor
                    : (isDark ? Colors.white30 : Colors.grey.shade400),
                width: 1.5,
              ),
            ),
            child: isMet
                ? const Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
                color: isMet
                    ? (isDark ? Colors.white : AppColors.blackColor)
                    : (isDark ? Colors.white54 : Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
