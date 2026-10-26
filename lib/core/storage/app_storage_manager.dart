import 'package:shared_preferences/shared_preferences.dart';
import 'secure_storage_manager.dart';
import 'shared_pref_manager.dart';
import 'storage_keys.dart';

/// Unified Storage Manager providing both Secure Storage and Shared Preferences access
class AppStorageManager {
  AppStorageManager._({
    required this.prefs,
    required this.secure,
  });

  static AppStorageManager? _instance;

  /// Global singleton instance (call [init] first)
  static AppStorageManager get instance {
    if (_instance == null) {
      throw StateError(
        'AppStorageManager must be initialized by calling await AppStorageManager.init() before use.',
      );
    }
    return _instance!;
  }

  /// SharedPreferences manager for non-sensitive data
  final SharedPrefManager prefs;

  /// SecureStorage manager for sensitive tokens and credentials
  final SecureStorageManager secure;

  /// Initialize the storage manager
  static Future<AppStorageManager> init({
    SharedPreferences? sharedPreferences,
    SecureStorageManager? secureStorage,
  }) async {
    final preferences = sharedPreferences ?? await SharedPreferences.getInstance();
    final secureMgr = secureStorage ?? SecureStorageManager();

    _instance = AppStorageManager._(
      prefs: SharedPrefManager(preferences),
      secure: secureMgr,
    );

    return _instance!;
  }

  // ==========================================
  // Auth & Security Helpers
  // ==========================================

  /// Save access and optional refresh token securely
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await secure.write(key: StorageKeys.accessToken, value: accessToken);
    if (refreshToken != null) {
      await secure.write(key: StorageKeys.refreshToken, value: refreshToken);
    }
    await prefs.setBool(StorageKeys.isLoggedIn, true);
  }

  /// Retrieve access token securely
  Future<String?> getAccessToken() async {
    return secure.read(key: StorageKeys.accessToken);
  }

  /// Retrieve refresh token securely
  Future<String?> getRefreshToken() async {
    return secure.read(key: StorageKeys.refreshToken);
  }

  /// Clear all authentication credentials
  Future<void> clearAuth() async {
    await secure.delete(key: StorageKeys.accessToken);
    await secure.delete(key: StorageKeys.refreshToken);
    await secure.delete(key: StorageKeys.userId);
    await prefs.setBool(StorageKeys.isLoggedIn, false);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return prefs.getBool(StorageKeys.isLoggedIn, defaultValue: false) ?? false;
  }

  /// Check if biometric auth is enabled
  bool isBiometricAuthEnabled() {
    return prefs.getBool(StorageKeys.biometricAuthEnabled, defaultValue: false) ?? false;
  }

  /// Set biometric auth enabled
  Future<bool> setBiometricAuthEnabled(bool enabled) {
    return prefs.setBool(StorageKeys.biometricAuthEnabled, enabled);
  }

  // ==========================================
  // Locale & Preferences Helpers
  // ==========================================

  /// Get preferred language code (e.g., 'en', 'sw')
  String? getLanguageCode() {
    return prefs.getString(StorageKeys.languageCode);
  }

  /// Set preferred language code
  Future<bool> setLanguageCode(String languageCode) {
    return prefs.setString(StorageKeys.languageCode, languageCode);
  }

  /// Get saved theme mode ('light', 'dark', 'system')
  String? getThemeMode() {
    return prefs.getString(StorageKeys.themeMode);
  }

  /// Save theme mode
  Future<bool> setThemeMode(String themeMode) {
    return prefs.setString(StorageKeys.themeMode, themeMode);
  }

  /// Check if first time user
  bool isFirstTimeUser() {
    return prefs.getBool(StorageKeys.isFirstTimeUser, defaultValue: true) ?? true;
  }

  /// Set first time user flag
  Future<bool> setFirstTimeUser(bool isFirstTime) {
    return prefs.setBool(StorageKeys.isFirstTimeUser, isFirstTime);
  }
}
