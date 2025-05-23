import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) => _sharedPreferences?.get(key);

  static bool? getBool({required String key}) => _sharedPreferences?.getBool(key);

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences!.setString(key, value);
    if (value is bool) return await _sharedPreferences!.setBool(key, value);
    if (value is int) return await _sharedPreferences!.setInt(key, value);
    if (value is double) return await _sharedPreferences!.setDouble(key, value);
    throw Exception("Unsupported type");
  }

  static Future<bool> removeData(String key) async {
    return await _sharedPreferences!.remove(key);
  }

  static Future<bool> clearAll() async {
    return await _sharedPreferences!.clear();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await _sharedPreferences!.setBool(key, value);
  }
}
