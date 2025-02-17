import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveCacheData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is String) return await sharedPreferences.setString(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  static dynamic getCacheData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeCacheData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> deleteAllCacheData({
    required String key,
  }) async {
    return await sharedPreferences.clear();
  }
}
