import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/helpers/helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
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

                    SizedBox(height: AppSpacing.md),

                    Text(
                      '${l10n.appName} App',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xs - 2),

                    Text(
                      l10n.appTagline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.tertiary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 16,
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 2.0,
                      constraints: const BoxConstraints(
                        minWidth: 25,
                        minHeight: 25,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),

                    SizedBox(height: AppSpacing.sm - 2),

                    // version info (App version: v<version-number>+<build-number>)
                    Text(
                      _appVersion.isNotEmpty
                          ? '${l10n.appVersion}: $_appVersion'
                          : '',
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
