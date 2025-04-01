import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static late SharedPreferences _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Set String value
  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// Get String value
  static String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Set Integer value
  static Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// Get Integer value
  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Set Boolean value
  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// Get Boolean value
  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Set Double value
  static Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  /// Get Double value
  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Set List of Strings
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// Get List of Strings
  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Clear all preferences
  static Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}

class SharedPreferenceKey{

  static const loginToken = "loginToken";
  static const googleToken = "googleToken";
  static const createPin = "createPin";
  static const walletAddress = "walletAddress";
  static const chainId = "ChainId";


}
