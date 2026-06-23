import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _nameKey = "user_name";
  static const _emailKey = "user_email";

  // ===================== TOKEN =====================

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ===================== REFRESH TOKEN =====================

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshKey);
  }

  // ===================== USER DATA =====================

  static Future<void> saveName(String name) async {
    await _storage.write(key: _nameKey, value: name);
  }

  static Future<String?> getName() async {
    return await _storage.read(key: _nameKey);
  }

  static Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  // ===================== CLEAR ALL =====================

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
