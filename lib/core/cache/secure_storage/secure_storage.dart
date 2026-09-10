import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract final class SecureStorageHelper {
  const SecureStorageHelper._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getString({required String key}) async {
    return _storage.read(key: key);
  }

  static Future<bool> containsKey({required String key}) async {
    return _storage.containsKey(key: key);
  }

  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
