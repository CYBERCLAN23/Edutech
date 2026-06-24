import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  static const String _defaultBaseUrl = 'http://localhost:3000/api';

  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;
  ApiClient._();

  String get baseUrl => _defaultBaseUrl;

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    if (kDebugMode) print('[API GET] $uri');
    final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>?> getWithOfflineFallback(
    String path, {
    Map<String, String>? query,
    required String cacheKey,
    Duration maxCacheAge = const Duration(hours: 1),
  }) async {
    try {
      final result = await get(path, query: query);
      _cacheOffline(cacheKey, result);
      return result;
    } catch (_) {
      final cached = _getOfflineCache(cacheKey);
      if (cached != null) return cached;
      rethrow;
    }
  }

  void _cacheOffline(String key, Map<String, dynamic> data) {
    try {
      final storage = _LocalCacheStore();
      storage.put(key, {
        'data': data,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (_) {}
  }

  Map<String, dynamic>? _getOfflineCache(String key) {
    try {
      final storage = _LocalCacheStore();
      final entry = storage.get(key);
      if (entry == null) return null;
      return entry['data'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    if (kDebugMode) print('[API POST] $uri');
    final response = await http
        .post(uri, headers: _headers, body: body != null ? jsonEncode(body) : null)
        .timeout(const Duration(seconds: 60));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http
        .put(uri, headers: _headers, body: body != null ? jsonEncode(body) : null)
        .timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.delete(uri, headers: _headers).timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadFile(String path, File file, {Map<String, String>? fields}) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      if (_token != null) 'Authorization': 'Bearer $_token',
    });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    if (fields != null) request.fields.addAll(fields);
    final streamed = await request.send().timeout(const Duration(minutes: 5));
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    if (response.statusCode == 401) {
      _token = null;
      throw ApiException('Session expirée. Veuillez vous reconnecter.', statusCode: 401);
    }
    throw ApiException(
      body['error'] as String? ?? 'Erreur serveur (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }
}

class _LocalCacheStore {
  Map<String, Map<String, dynamic>> _mem = {};
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/api_cache.json');
      if (await file.exists()) {
        final raw = await file.readAsString();
        _mem = Map<String, Map<String, dynamic>>.from(
          (jsonDecode(raw) as Map).map((k, v) => MapEntry(k as String, v as Map<String, dynamic>)),
        );
      }
    } catch (_) {}
    _initialized = true;
  }

  Future<void> _save() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/api_cache.json');
      await file.writeAsString(jsonEncode(_mem));
    } catch (_) {}
  }

  Map<String, dynamic>? get(String key) {
    return _mem[key];
  }

  Future<void> put(String key, Map<String, dynamic> value) async {
    await _ensureInit();
    if (_mem.length > 100) {
      final keys = _mem.keys.toList();
      _mem.remove(keys[Random().nextInt(keys.length)]);
    }
    _mem[key] = value;
    await _save();
  }
}
