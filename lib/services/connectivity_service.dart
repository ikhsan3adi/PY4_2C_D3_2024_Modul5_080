import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logbook_app_080/helpers/log_helper.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isOnline = ValueNotifier(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  VoidCallback? onReconnected;

  ConnectivityService({this.onReconnected});

  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final wasOffline = !isOnline.value;
      _updateStatus(results);

      if (wasOffline && isOnline.value) {
        LogHelper.writeLog(
          'CONNECTIVITY: Koneksi pulih, memulai sinkronisasi...',
          source: 'connectivity_service.dart',
          level: 2,
        );
        onReconnected?.call();
      }
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    isOnline.value = online;

    LogHelper.writeLog(
      'CONNECTIVITY: Status = ${online ? "Online" : "Offline"}',
      source: 'connectivity_service.dart',
      level: 3,
    );
  }

  void dispose() {
    _subscription?.cancel();
    isOnline.dispose();
  }
}
