import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/auth/presentation/screens/auth_gate.dart';
import 'package:kijumbe_app/features/onboarding/presentation/widgets/splash_branding.dart';
import 'package:kijumbe_app/helpers/helpers.dart';

class SplashScreen extends StatefulWidget {
  final Duration navigationDelay;
  final Duration loadingDelay;
  final Duration brandingDuration;

  const SplashScreen({
    super.key,
    this.navigationDelay = const Duration(milliseconds: 5000),
    this.loadingDelay = const Duration(seconds: 2),
    this.brandingDuration = const Duration(milliseconds: 1400),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appVersion = 'v1.0.0+1';
  bool _showLoading = false;
  Timer? _loadingTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    // Loading indicator delays by loadingDelay (2s) after logo and description have appeared
    _loadingTimer = Timer(widget.brandingDuration + widget.loadingDelay, () {
      if (!mounted) return;
      setState(() {
        _showLoading = true;
      });
    });

    // Start navigation timer to proceed to AuthGate after splash flow
    _navigationTimer = Timer(widget.navigationDelay, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AuthGate()),
      );
    });
  }

  void _onBrandingComplete() {
    // Branding animation sequence complete
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final version = await AppInfoHelper.getAppVersion();
    if (mounted) {
      setState(() {
        _appVersion = version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Sequential animated branding: Logo -> App Name -> Description
              Center(
                child: SplashBranding(
                  appName: '${l10n.appName} App',
                  appTagline: l10n.appTagline,
                  duration: widget.brandingDuration,
                  onAnimationComplete: _onBrandingComplete,
                ),
              ),

              Positioned(
                bottom: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Loading indicator delays 2s after logo & description appear
                    AnimatedOpacity(
                      opacity: _showLoading ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                      child: CircularProgressIndicator(
                        key: const Key('splash_loading_indicator'),
                        strokeWidth: 2.0,
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          minHeight: 25,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.sm - 2),

                    // Version info is always visible with zero delay
                    Text(
                      '${l10n.appVersion}: $_appVersion',
                      key: const Key('splash_version_text'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                        fontSize: AppTextSizes.sm - 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
