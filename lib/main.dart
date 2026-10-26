import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage manager (SharedPreferences & SecureStorage)
  await AppStorageManager.init();

  // Initialize localization manager with persisted preferences
  LocaleManager.init();

  // Initialize theme manager with persisted preferences (defaults to light)
  ThemeManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        LocaleManager.instance,
        ThemeManager.instance,
      ]),
      builder: (context, _) {
        final localeManager = LocaleManager.instance;
        final themeManager = ThemeManager.instance;

        return MaterialApp(
          title: Constants.appName,
          debugShowCheckedModeBanner: false,

          // Theme Configuration
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,

          // Localization Configuration
          locale: localeManager.currentLocale,
          supportedLocales: AppLocales.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,

          // Entry Screen
          home: const SplashScreen(),
        );
      },
    );
  }
}
