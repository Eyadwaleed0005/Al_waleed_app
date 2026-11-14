import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  static Future<String?> getString({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  static Future<void> saveInt({required String key, required int value}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(key, value);
  }

  static Future<int?> getInt({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final isSaved = await prefs.setBool(key, value);

    if (!isSaved) {
      throw StateError('Failed to save boolean preference: $key');
    }
  }

  static Future<bool?> getBool({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  static Future<void> saveDouble({
    required String key,
    required double value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(key);
  }

  static Future<void> removeData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  static Future<bool> containsKey({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  static Future<void> clearAllExcept({required Set<String> keysToKeep}) async {
    final prefs = await SharedPreferences.getInstance();

    final keysToRemove = prefs
        .getKeys()
        .where((key) => !keysToKeep.contains(key))
        .toList();

    for (final key in keysToRemove) {
      final removed = await prefs.remove(key);

      if (!removed) {
        throw StateError('Failed to remove preference: $key');
      }
    }
  }
}
