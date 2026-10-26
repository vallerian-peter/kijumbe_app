import 'package:flutter/material.dart';
import '../storage/storage.dart';
import 'app_locale.dart';

/// App-wide Locale Manager for controlling and persisting language settings
class LocaleManager extends ChangeNotifier {
  LocaleManager._({required AppStorageManager storage}) : _storage = storage {
    _loadSavedLocale();
  }

  static LocaleManager? _instance;
  final AppStorageManager _storage;
  Locale _currentLocale = AppLocales.defaultLocale;

  /// Global singleton instance
  static LocaleManager get instance {
    if (_instance == null) {
      throw StateError(
        'LocaleManager must be initialized by calling LocaleManager.init() before use.',
      );
    }
    return _instance!;
  }

  /// Initialize LocaleManager with storage
  static LocaleManager init({AppStorageManager? storage}) {
    final storageManager = storage ?? AppStorageManager.instance;
    _instance = LocaleManager._(storage: storageManager);
    return _instance!;
  }

  /// Current active locale
  Locale get currentLocale => _currentLocale;

  /// Whether current language is Swahili
  bool get isSwahili => _currentLocale.languageCode == 'sw';

  /// Whether current language is English
  bool get isEnglish => _currentLocale.languageCode == 'en';

  void _loadSavedLocale() {
    final savedCode = _storage.getLanguageCode();
    if (savedCode != null &&
        AppLocales.supportedLocales.any((l) => l.languageCode == savedCode)) {
      _currentLocale = Locale(savedCode);
    }
  }

  /// Change active locale and persist selection
  Future<void> setLocale(Locale newLocale) async {
    if (!AppLocales.supportedLocales.contains(newLocale)) return;
    if (_currentLocale == newLocale) return;

    _currentLocale = newLocale;
    await _storage.setLanguageCode(newLocale.languageCode);
    notifyListeners();
  }

  /// Switch between English and Swahili
  Future<void> toggleLanguage() async {
    final nextLocale = isEnglish ? AppLocales.swahili : AppLocales.english;
    await setLocale(nextLocale);
  }
}
