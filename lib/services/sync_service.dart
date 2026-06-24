import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:educam_ai/services/local_storage_service.dart';
import 'package:educam_ai/services/offline_service.dart';
import 'package:educam_ai/services/api_client.dart';

enum SyncStatus { idle, syncing, error }

class SyncService {
  static final SyncService _instance = SyncService._();
  factory SyncService() => _instance;
  SyncService._();

  final _storage = LocalStorageService();
  final _offline = OfflineService();
  final _api = ApiClient();

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get onStatusChanged => _statusController.stream;

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  StreamSubscription? _connectivitySub;

  int _syncedCount = 0;
  int get syncedCount => _syncedCount;

  void init() {
    _connectivitySub = _offline.onStatusChanged.listen((status) {
      if (status == ConnectivityStatus.online) {
        syncPending();
      }
    });
  }

  Future<void> syncPending() async {
    if (_status == SyncStatus.syncing) return;
    if (!_offline.isOnline) return;

    _status = SyncStatus.syncing;
    _statusController.add(SyncStatus.syncing);
    _syncedCount = 0;

    try {
      final items = _storage.getPendingSyncItems();
      if (kDebugMode) print('[SyncService] Syncing ${items.length} items');

      for (final item in items) {
        try {
          await _syncItem(item);
          await _storage.removeSyncItem(item['payload_id'] as String);
          _syncedCount++;
        } catch (e) {
          if (kDebugMode) print('[SyncService] Failed to sync item: $e');
        }
      }

      _status = SyncStatus.idle;
      _statusController.add(SyncStatus.idle);

      if (_syncedCount > 0 && kDebugMode) {
        print('[SyncService] Synced $_syncedCount items successfully');
      }
    } catch (e) {
      _status = SyncStatus.error;
      _statusController.add(SyncStatus.error);
      if (kDebugMode) print('[SyncService] Sync error: $e');
    }
  }

  Future<void> _syncItem(Map<String, dynamic> item) async {
    final type = item['type'] as String;

    switch (type) {
      case 'quiz_answer':
        await _syncQuizAnswer(item['payload_id'] as String);
        break;
    }
  }

  Future<void> _syncQuizAnswer(String answerId) async {
    final answer = _storage.getUnsyncedAnswer(answerId);
    if (answer == null) return;

    try {
      await _api.post('/quizzes/submit', body: {
        'quiz_id': answer['quiz_id'],
        'course_id': answer['course_id'],
        'answers': answer['answers'],
        'score': answer['score'],
        'total': answer['total'],
        'time_spent': answer['time_spent'],
        'offline_submitted_at': answer['_created_at'],
      });
      await _storage.markAnswerSynced(answerId);
    } catch (e) {
      if (kDebugMode) print('[SyncService] Quiz answer sync failed: $e');
      rethrow;
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
    _statusController.close();
  }
}
