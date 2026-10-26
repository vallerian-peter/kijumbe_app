import 'package:flutter/material.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// App-wide Locale constants and extensions
abstract class AppLocales {
  static const Locale english = Locale('en');
  static const Locale swahili = Locale('sw');

  static const List<Locale> supportedLocales = [
    english,
    swahili,
  ];

  static const Locale defaultLocale = english;

  /// Returns user-friendly language name
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'sw':
        return 'Kiswahili';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Returns flag emoji or code symbol
  static String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'sw':
        return '🇹🇿';
      case 'en':
      default:
        return '🇬🇧';
    }
  }
}

/// Convenience extension on [BuildContext] to access [AppLocalizations] cleanly:
/// `context.l10n.welcome`
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    assert(
      localizations != null,
      'No AppLocalizations found in context. Ensure localizationsDelegates and supportedLocales are set in MaterialApp.',
    );
    return localizations!;
  }
}
