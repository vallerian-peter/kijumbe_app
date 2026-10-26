import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../kijumbe/kijumbe.dart';

/// A celebratory screen displayed after successful profile and NIDA verification.
/// Features falling celebration confetti particles, an animated shimmer congratulations badge,
/// and a bottom proceed action button, inspired by modern banking onboarding flows.
class RegistrationSuccessScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String? firstName;
  final String? phone;
  final String? buttonText;
  final VoidCallback? onProceed;
  final void Function(BuildContext context)? onProceedWithContext;
  final Widget? destinationScreen;

  const RegistrationSuccessScreen({
    super.key,
    this.title,
    this.description,
    this.firstName,
    this.phone,
    this.buttonText,
    this.onProceed,
    this.onProceedWithContext,
    this.destinationScreen,
  });

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  late final ConfettiController _celebrationController = ConfettiController(
    duration: const Duration(milliseconds: 3000),
  )..play();

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void _handleProceed() {
    if (widget.onProceedWithContext != null) {
      widget.onProceedWithContext!(context);
      return;
    }
    if (widget.onProceed != null) {
      widget.onProceed!();
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => widget.destinationScreen ?? const KijumbeDashboard(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    final defaultDescription = widget.firstName != null &&
            widget.firstName!.trim().isNotEmpty
        ? '${l10n.welcome}, ${widget.firstName}! ${l10n.registrationSuccessSubtitle}'
        : l10n.registrationSuccessSubtitle;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Falling Celebration Confetti Particles across the top of the screen
          Positioned.fill(
            child: IgnorePointer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  6,
                  (_) => Expanded(child: _buildConfettiEmitter()),
                ),
              ),
            ),
          ),

          // Main Centered Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Celebratory Hero Handshake Badge in Green Theme
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.greenColor.withValues(alpha: 0.22),
                          AppColors.greenColor.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E232A) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.greenColor.withValues(alpha: 0.45),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greenColor.withValues(alpha: 0.25),
                              blurRadius: 28,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          AppAssets.successfulHandshakeGreen,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.check_circle_rounded,
                            size: 58,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title
                  Text(
                    widget.title ?? l10n.registrationSuccessTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.description ?? defaultDescription,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.45,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Bottom Proceed Action Button
                  CustomButon(
                    text: widget.buttonText ?? l10n.proceed,
                    height: 54,
                    borderRadius: 27,
                    onPressed: _handleProceed,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiEmitter() {
    return ConfettiWidget(
      confettiController: _celebrationController,
      blastDirectionality: BlastDirectionality.directional,
      blastDirection: math.pi / 2, // Falling downwards
      emissionFrequency: 0.035,
      numberOfParticles: 3,
      minBlastForce: 3,
      maxBlastForce: 9,
      gravity: 0.18,
      particleDrag: 0.05,
      minimumSize: const Size(6, 10),
      maximumSize: const Size(9, 16),
      shouldLoop: false,
      colors: const [
        AppColors.appPrimaryColor,
        AppColors.appPrimaryLightColor,
        Color(0xFFFFB300), // Amber
        Color(0xFF00E676), // Bright green
        Color(0xFF29B6F6), // Sky blue
        Color(0xFFFF4081), // Pink accent
      ],
    );
  }
}
