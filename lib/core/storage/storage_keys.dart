/// Centralized keys for local and secure storage
abstract class StorageKeys {
  // Secure Storage Keys
  static const String accessToken = 'kijumbe_access_token';
  static const String refreshToken = 'kijumbe_refresh_token';
  static const String userId = 'kijumbe_user_id';
  static const String userPin = 'kijumbe_user_pin';
  static const String encryptionKey = 'kijumbe_encryption_key';

  // Shared Preferences Keys
  static const String languageCode = 'kijumbe_language_code';
  static const String themeMode = 'kijumbe_theme_mode';
  static const String isFirstTimeUser = 'kijumbe_is_first_time_user';
  static const String isLoggedIn = 'kijumbe_is_logged_in';
  static const String cachedUserProfile = 'kijumbe_cached_user_profile';
  static const String notificationsEnabled = 'kijumbe_notifications_enabled';
  static const String biometricAuthEnabled = 'kijumbe_biometric_auth_enabled';
}
