import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/auth.dart';
import '../widgets/widgets.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    final isShortScreen = size.height < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.skySoftGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;
              final orbitDiameter = math.min(
                availableWidth - 32,
                availableHeight * 0.44,
              ).clamp(220.0, 360.0);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top Illustration with Orbit and 3D Icons
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: OrbitIllustration(
                            diameter: orbitDiameter,
                            controller: _controller,
                          ),
                        ),

                        // Bottom Content Section
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Main Headline
                            Text(
                              l10n.getStartedHeadline,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isShortScreen ? 25 : 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.blackColor,
                                letterSpacing: -0.5,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Subtitle
                            Text(
                              l10n.getStartedSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isShortScreen ? 13 : 14,
                                color: AppColors.blackColor.withValues(alpha: 0.65),
                                height: 1.45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Primary Button: "Get Started"
                            CustomButon(
                              text: l10n.getStarted,
                              height: 54,
                              borderRadius: 27,
                              onPressed: () {
                                RegistrationTypeBottomSheet.show(context);
                              },
                            ),
                            const SizedBox(height: 12),

                            // Secondary Button: "I already have an account"
                            CustomButon.outlined(
                              text: l10n.iAlreadyHaveAnAccount,
                              height: 54,
                              borderRadius: 27,
                              bgColor: Colors.white,
                              borderColor: Colors.grey.shade300,
                              textColor: Colors.grey.shade600,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPhoneScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
