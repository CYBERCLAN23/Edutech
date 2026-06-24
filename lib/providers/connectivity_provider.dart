import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/services/offline_service.dart';
import 'package:educam_ai/services/sync_service.dart';

final offlineServiceProvider = Provider<OfflineService>((ref) {
  final service = OfflineService();
  ref.onDispose(() => service.dispose());
  return service;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(offlineServiceProvider);
  return service.onStatusChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityStatusProvider);
  return connectivity.valueOrNull == ConnectivityStatus.online;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.onStatusChanged;
});

final syncedCountProvider = Provider<int>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.syncedCount;
});
