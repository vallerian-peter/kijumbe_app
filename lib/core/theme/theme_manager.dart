import 'package:flutter/material.dart';
import '/core/core.dart';

/// App-wide Theme Manager for controlling and persisting theme settings.
/// Defaults to [ThemeMode.light] if no theme is previously stored.
class ThemeManager extends ChangeNotifier {
  ThemeManager._({required AppStorageManager storage}) : _storage = storage {
    _loadSavedThemeMode();
  }

  static ThemeManager? _instance;
  final AppStorageManager _storage;
  ThemeMode _themeMode = ThemeMode.light;

  /// Global singleton instance
  static ThemeManager get instance {
    if (_instance == null) {
      throw StateError(
        'ThemeManager must be initialized by calling ThemeManager.init() before use.',
      );
    }
    return _instance!;
  }

  /// Initialize ThemeManager with storage
  static ThemeManager init({AppStorageManager? storage}) {
    final storageManager = storage ?? AppStorageManager.instance;
    _instance = ThemeManager._(storage: storageManager);
    return _instance!;
  }

  /// Current active ThemeMode
  ThemeMode get themeMode => _themeMode;

  /// Whether current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Whether current theme is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Loads saved theme from storage. If empty, saves and defaults to 'light'.
  void _loadSavedThemeMode() {
    final savedMode = _storage.getThemeMode();
    if (savedMode == null || savedMode.isEmpty) {
      _themeMode = ThemeMode.light;
      _storage.setThemeMode('light');
    } else {
      switch (savedMode.toLowerCase()) {
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
          _themeMode = ThemeMode.system;
          break;
        case 'light':
        default:
          _themeMode = ThemeMode.light;
          break;
      }
    }
  }

  /// Updates active theme mode and persists it to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    final String modeString;
    switch (mode) {
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
      case ThemeMode.light:
        modeString = 'light';
        break;
    }
    await _storage.setThemeMode(modeString);
    notifyListeners();
  }

  /// Toggles between light and dark theme
  Future<void> toggleTheme() async {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }
}
