import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';

/// Animated branding block for SplashScreen containing smooth staggered entrance
/// for the app logo, app title, and tagline/subtitle.
class SplashBranding extends StatefulWidget {
  const SplashBranding({
    super.key,
    required this.appName,
    this.appTagline,
    this.duration = const Duration(milliseconds: 1400),
    this.onAnimationComplete,
  });

  final String appName;
  final String? appTagline;
  final Duration duration;
  final VoidCallback? onAnimationComplete;

  @override
  State<SplashBranding> createState() => _SplashBrandingState();
}

class _SplashBrandingState extends State<SplashBranding>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    // 1. Logo: Scales up smoothly from 0.6 to 1.0 with subtle overshoot
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    );

    // 2. App Title: Slides up smoothly and fades in right after the logo starts
    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.70, curve: Curves.easeIn),
    );

    // 3. Subtitle / Tagline: Slides up smoothly following the title
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.48, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.48, 0.95, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tagline = widget.appTagline ??
        (AppLocalizations.of(context)?.appTagline ?? 'Save Together, Grow Together');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Animated Logo
        FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(
            scale: _logoScale,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                AppAssets.appLogo,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.appPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // 2. Animated Title
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Text(
              widget.appName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: AppSpacing.xs - 2),

        // 3. Animated Subtitle / Tagline
        FadeTransition(
          opacity: _subtitleFade,
          child: SlideTransition(
            position: _subtitleSlide,
            child: Text(
              tagline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
