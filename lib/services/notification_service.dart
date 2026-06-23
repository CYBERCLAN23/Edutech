import 'package:educam_ai/services/api_client.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _api = ApiClient();

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final result = await _api.get('/notifications');
    return List<Map<String, dynamic>>.from(result['data'] as List);
  }

  Future<void> markRead(String id) async {
    await _api.put('/notifications/$id/read');
  }
}
