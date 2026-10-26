import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:kijumbe_app/helpers/biometric_auth_helper.dart';

/// Authentication Gate checking security state (Biometric Login preference).
/// - If biometric is enabled and present on device, prompts biometric scan.
/// - On successful authentication (or if biometric is disabled), redirects to destination (GetStartedScreen).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isChecking = true;
  bool _authFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricAndProceed();
    });
  }

  Future<void> _checkBiometricAndProceed() async {
    final isBiometricEnabled =
        AppStorageManager.instance.isBiometricAuthEnabled();

    // If biometric login is disabled, continue redirection directly
    if (!isBiometricEnabled) {
      _navigateToDestination();
      return;
    }

    // Check if biometric authentication hardware and credentials are present
    final isAvailable = await BiometricAuthHelper.isBiometricAvailable();
    if (!isAvailable) {
      // Biometric was enabled in settings, but device hardware or enrollment is not present
      _navigateToDestination();
      return;
    }

    // Biometric is enabled & present: show biometric authentication prompt
    final authenticated = await BiometricAuthHelper.authenticate(
      reason: 'Please authenticate with your fingerprint or face to open Kijumbe',
    );

    if (!mounted) return;

    if (authenticated) {
      _navigateToDestination();
    } else {
      setState(() {
        _isChecking = false;
        _authFailed = true;
      });
    }
  }

  void _navigateToDestination() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSw = Localizations.localeOf(context).languageCode == 'sw';

    if (_isChecking) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Biometric Icon Container
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryTealGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  color: Colors.white,
                  size: 46,
                ),
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                isSw
                    ? 'Uthibitishaji wa Biometria'
                    : 'Biometric Verification',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.blackColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                isSw
                    ? 'Weka alama ya kidole chako au utambuzi wa uso ili kufungua akaunti yako ya Kijumbe.'
                    : 'Scan your fingerprint or face recognition to unlock your Kijumbe account.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.4,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              if (_authFailed) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.redColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: AppColors.redColor, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isSw
                              ? 'Uthibitishaji haukufaulu. Tafadhali jaribu tena.'
                              : 'Authentication failed. Please try again.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Try Again Button
              CustomButon(
                text: isSw ? 'Thibitisha Tena' : 'Unlock with Biometrics',
                height: 52,
                borderRadius: 26,
                onPressed: () {
                  setState(() {
                    _isChecking = true;
                    _authFailed = false;
                  });
                  _checkBiometricAndProceed();
                },
              ),

              const SizedBox(height: 14),

              // Fallback / Continue Button
              TextButton(
                onPressed: _navigateToDestination,
                child: Text(
                  isSw ? 'Endelea kwa Njia Mbadala' : 'Proceed to App',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.darkGreyColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
