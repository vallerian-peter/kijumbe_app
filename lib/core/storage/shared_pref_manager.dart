import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Manager wrapping [SharedPreferences] for non-sensitive data
class SharedPrefManager {
  SharedPrefManager(this._prefs);

  final SharedPreferences _prefs;

  // String
  String? getString(String key, {String? defaultValue}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // Boolean
  bool? getBool(String key, {bool? defaultValue}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // Integer
  int? getInt(String key, {int? defaultValue}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // Double
  double? getDouble(String key, {double? defaultValue}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  // StringList
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  // Check key
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Remove key
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return _prefs.clear();
  }
}
