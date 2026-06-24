import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus { online, offline }

class OfflineService {
  static final OfflineService _instance = OfflineService._();
  factory OfflineService() => _instance;
  OfflineService._();

  final _connectivity = Connectivity();
  final _statusController = StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _status = ConnectivityStatus.online;
  ConnectivityStatus get status => _status;
  bool get isOnline => _status == ConnectivityStatus.online;
  bool get isOffline => _status == ConnectivityStatus.offline;

  Stream<ConnectivityStatus> get onStatusChanged => _statusController.stream;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final wasOnline = _status == ConnectivityStatus.online;
    final nowOnline = results.any((r) => r != ConnectivityResult.none);

    if (nowOnline) {
      _status = ConnectivityStatus.online;
    } else {
      _status = ConnectivityStatus.offline;
    }

    if (wasOnline != (nowOnline)) {
      if (kDebugMode) {
        print('[OfflineService] Status changed: ${_status.name}');
      }
      _statusController.add(_status);
    }
  }

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    final online = results.any((r) => r != ConnectivityResult.none);
    _status = online ? ConnectivityStatus.online : ConnectivityStatus.offline;
    return online;
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
