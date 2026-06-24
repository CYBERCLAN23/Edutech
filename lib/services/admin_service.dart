import 'package:educam_ai/services/api_client.dart';

class AdminService {
  static final AdminService _instance = AdminService._();
  factory AdminService() => _instance;
  AdminService._();

  final _api = ApiClient();

  Future<Map<String, dynamic>> getDashboard() async {
    final result = await _api.get('/admin/dashboard');
    return result['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getUsers({String? role}) async {
    final query = <String, String>{};
    if (role != null) query['role'] = role;
    final result = await _api.get('/admin/users', query: query);
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<void> deleteUser(String id) async {
    await _api.delete('/admin/users/$id');
  }

  Future<Map<String, dynamic>> getCourses() async {
    final result = await _api.get('/admin/courses');
    return result['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getActivities({int limit = 20}) async {
    final result = await _api.get('/admin/activities', query: {'limit': limit.toString()});
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<List<Map<String, dynamic>>> getClassStats() async {
    final result = await _api.get('/admin/stats/classes');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }
}
