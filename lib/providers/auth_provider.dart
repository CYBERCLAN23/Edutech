import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final Map<String, dynamic>? user;
  final String? error;
  final bool isTeacher;
  final bool isStudent;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isTeacher = false,
    this.isStudent = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    Map<String, dynamic>? user,
    String? error,
    bool? isTeacher,
    bool? isStudent,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isTeacher: isTeacher ?? this.isTeacher,
      isStudent: isStudent ?? this.isStudent,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _auth;

  AuthStateNotifier(this._auth) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final data = await _auth.login(email, password);
      final user = data['user'] as Map<String, dynamic>;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: user['role'] == 'teacher',
        isStudent: user['role'] == 'student',
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? className,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final data = await _auth.register(
        email: email,
        password: password,
        name: name,
        role: role,
        className: className,
      );
      final user = data['user'] as Map<String, dynamic>;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: user['role'] == 'teacher',
        isStudent: user['role'] == 'student',
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadSession(String token) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _auth.loadSession(token);
      final user = _auth.currentUser;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: user?['role'] == 'teacher',
        isStudent: user?['role'] == 'student',
      );
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void logout() {
    _auth.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
