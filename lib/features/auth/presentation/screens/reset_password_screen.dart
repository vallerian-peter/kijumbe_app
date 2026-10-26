import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/helpers/helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? phoneNumber;

  const ResetPasswordScreen({
    super.key,
    this.phoneNumber,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordController.addListener(_onTextChanged);
    _confirmPasswordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onTextChanged);
    _confirmPasswordController.removeListener(_onTextChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Password validation rules via ValidatorHelper
  bool get _hasMinLength =>
      ValidatorHelper.hasMinLength(_passwordController.text);
  bool get _hasUppercase =>
      ValidatorHelper.hasUppercase(_passwordController.text);
  bool get _hasNumber =>
      ValidatorHelper.hasNumber(_passwordController.text);

  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _isPasswordValid =>
      ValidatorHelper.isStrongPassword(_passwordController.text);

  bool get _canSubmit => _isPasswordValid && _passwordsMatch;

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final l10n = context.l10n;
      if (!_passwordsMatch) {
        CustomToast.showWarning(context, l10n.passwordsDoNotMatch);
        return;
      }

      // Show success toast
      CustomToast.showSuccess(context, l10n.passwordResetSuccess);

      // Navigate back to LoginScreen
      Navigator.of(context).popUntil((route) => route.isFirst);
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
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          l10n.resetPassword,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle
                      Text(
                        l10n.resetPasswordSubtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // New Password Field
                      CustomTextField(
                        controller: _passwordController,
                        isDark: true,
                        label: l10n.newPassword,
                        hintText: l10n.newPasswordHint,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
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

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        isDark: true,
                        label: l10n.confirmPassword,
                        hintText: l10n.confirmPasswordHint,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.passwordRequired;
                          }
                          if (value != _passwordController.text) {
                            return l10n.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Password Requirements Card
                      PasswordInstructionCard(
                        hasMinLength: _hasMinLength,
                        hasUppercase: _hasUppercase,
                        hasNumber: _hasNumber,
                        passwordsMatch: _passwordsMatch,
                        isDark: true,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: const BoxDecoration(
                color: AppColors.blackColor,
              ),
              child: CustomButon(
                text: l10n.resetPassword,
                height: 54,
                borderRadius: 27,
                onPressed: _canSubmit ? _onSubmit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

