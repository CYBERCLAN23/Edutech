import 'package:educam_ai/services/api_client.dart';

class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  final _api = ApiClient();

  String? _token;
  Map<String, dynamic>? _currentUser;

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null;
  bool get isTeacher => _currentUser?['role'] == 'teacher';
  bool get isStudent => _currentUser?['role'] == 'student';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _api.post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    final data = result['data'] as Map<String, dynamic>;
    _token = data['token'] as String;
    _currentUser = data['user'] as Map<String, dynamic>;
    _api.setToken(_token);
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? className,
  }) async {
    final result = await _api.post('/auth/register', body: {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
      if (className != null) 'class_name': className,
    });

    final data = result['data'] as Map<String, dynamic>;
    _token = data['token'] as String;
    _currentUser = data['user'] as Map<String, dynamic>;
    _api.setToken(_token);
    return data;
  }

  Future<void> loadSession(String token) async {
    _api.setToken(token);
    _token = token;
    try {
      final result = await _api.get('/auth/me');
      _currentUser = result['data'] as Map<String, dynamic>;
    } catch (e) {
      _token = null;
      _currentUser = null;
      _api.setToken(null);
      rethrow;
    }
  }

  void logout() {
    _token = null;
    _currentUser = null;
    _api.setToken(null);
  }
}
