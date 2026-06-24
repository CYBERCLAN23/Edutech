import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/auth_service.dart';
import 'package:educam_ai/models/app_role.dart';

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
  final bool isAdmin;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isTeacher = false,
    this.isStudent = false,
    this.isAdmin = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    Map<String, dynamic>? user,
    String? error,
    bool? isTeacher,
    bool? isStudent,
    bool? isAdmin,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isTeacher: isTeacher ?? this.isTeacher,
      isStudent: isStudent ?? this.isStudent,
      isAdmin: isAdmin ?? this.isAdmin,
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
      final role = user['role'] as String;
      AppSession.currentRole = role == 'teacher' ? AppRole.teacher : role == 'admin' ? AppRole.admin : AppRole.student;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: role == 'teacher',
        isStudent: role == 'student',
        isAdmin: role == 'admin',
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
      AppSession.currentRole = role == 'teacher' ? AppRole.teacher : AppRole.student;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: user['role'] == 'teacher',
        isStudent: user['role'] == 'student',
        isAdmin: user['role'] == 'admin',
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
      final role = user?['role'] as String?;
      AppSession.currentRole = role == 'teacher' ? AppRole.teacher : role == 'admin' ? AppRole.admin : AppRole.student;
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isTeacher: role == 'teacher',
        isStudent: role == 'student',
        isAdmin: role == 'admin',
      );
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void logout() {
    _auth.logout();
    AppSession.currentRole = null;
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
