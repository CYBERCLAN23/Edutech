import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheService {
  static final CacheService _instance = CacheService._();
  factory CacheService() => _instance;
  CacheService._();

  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _prefix = 'cache_';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> cacheData(String key, dynamic data) async {
    final json = jsonEncode({
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await _storage.write(key: '$_prefix$key', value: json);
  }

  Future<Map<String, dynamic>?> getCachedData(String key, {Duration maxAge = const Duration(hours: 1)}) async {
    final raw = await _storage.read(key: '$_prefix$key');
    if (raw == null) return null;

    try {
      final cached = jsonDecode(raw) as Map<String, dynamic>;
      final timestamp = cached['timestamp'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;

      if (age > maxAge.inMilliseconds) {
        await _storage.delete(key: '$_prefix$key');
        return null;
      }

      return cached;
    } catch (_) {
      await _storage.delete(key: '$_prefix$key');
      return null;
    }
  }

  Future<void> clearAll() async {
    final all = await _storage.readAll();
    for (final key in all.keys) {
      if (key.startsWith(_prefix) || key == _tokenKey) {
        await _storage.delete(key: key);
      }
    }
  }
}
