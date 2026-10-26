import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Manager wrapping [FlutterSecureStorage] for handling sensitive data
class SecureStorageManager {
  SecureStorageManager({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  /// Write a sensitive value
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a sensitive value
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  /// Check if key exists
  Future<bool> containsKey({required String key}) async {
    return _storage.containsKey(key: key);
  }

  /// Delete a specific key
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Delete all keys in secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Read all keys and values as a Map
  Future<Map<String, String>> readAll() async {
    return _storage.readAll();
  }
}
