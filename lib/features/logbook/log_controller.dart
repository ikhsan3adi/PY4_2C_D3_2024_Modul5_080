import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logbook_app_080/features/logbook/models/log_model.dart';
import 'package:logbook_app_080/helpers/log_helper.dart';
import 'package:logbook_app_080/services/access_control_service.dart';
import 'package:logbook_app_080/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class LogController {
  final ValueNotifier<List<LogModel>> logsNotifier = ValueNotifier([]);
  final ValueNotifier<List<LogModel>> filteredLogs = ValueNotifier([]);

  final String username;
  final String authorId;
  final String teamId;
  final String userRole;

  final _box = Hive.box<LogModel>('offline_logs');

  LogController({
    required this.username,
    required this.authorId,
    required this.teamId,
    required this.userRole,
  }) {
    logsNotifier.addListener(() => filteredLogs.value = logsNotifier.value);
  }

  void dispose() {
    logsNotifier.dispose();
    filteredLogs.dispose();
  }

  List<LogModel> get logs => logsNotifier.value;

  Future<void> addLog(
    String title,
    String desc, {
    String category = 'Pribadi',
    String? authorId,
    String? teamId,
  }) async {
    final newLog = LogModel(
      id: ObjectId().oid,
      username: username,
      title: title,
      description: desc,
      timestamp: DateTime.now().toString(),
      category: category,
      authorId: authorId ?? this.authorId,
      teamId: teamId ?? this.teamId,
    );

    await _box.add(newLog);
    logsNotifier.value = [...logsNotifier.value, newLog];
    // filteredLogs.value = [...logsNotifier.value, newLog];

    try {
      await MongoService().insertLog(newLog);

      await LogHelper.writeLog(
        "SUCCESS: Tambah data '${newLog.title}'",
        source: 'log_controller.dart',
      );
    } catch (e) {
      await LogHelper.writeLog(
        'ERROR: Gagal sinkronisasi Add - $e',
        source: 'log_controller.dart',
        level: 1,
      );
    }
  }

  Future<void> updateLog(
    int index,
    String title,
    String desc, {
    String category = 'Pribadi',
  }) async {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    final oldLog = currentLogs[index];

    // Security check lapis kedua (Controller-level)
    final bool isOwner = oldLog.authorId == authorId;
    if (!AccessControlService.canPerform(
      userRole,
      AccessControlService.actionUpdate,
      isOwner: isOwner,
    )) {
      await LogHelper.writeLog(
        'SECURITY: Unauthorized update attempt by $authorId',
        source: 'log_controller.dart',
        level: 1,
      );
      return;
    }

    final updatedLog = LogModel(
      id: oldLog.id,
      username: username,
      title: title,
      description: desc,
      timestamp: DateTime.now().toString(),
      category: category,
      authorId: authorId,
      teamId: teamId,
    );

    await _box.putAt(index, updatedLog);
    currentLogs[index] = updatedLog;
    logsNotifier.value = currentLogs;
    // filteredLogs.value = currentLogs;

    try {
      await MongoService().updateLog(updatedLog);

      await LogHelper.writeLog(
        "SUCCESS: Sinkronisasi Update '${oldLog.title}' Berhasil",
        source: 'log_controller.dart',
        level: 2,
      );
    } catch (e) {
      await LogHelper.writeLog(
        'ERROR: Gagal sinkronisasi Update - $e',
        source: 'log_controller.dart',
        level: 1,
      );
    }
  }

  Future<void> removeLog(int index) async {
    final currentLogs = List<LogModel>.from(logsNotifier.value);
    final targetLog = currentLogs[index];

    // Controller-level Security check
    final bool isOwner = targetLog.authorId == authorId;
    if (!AccessControlService.canPerform(
      userRole,
      AccessControlService.actionDelete,
      isOwner: isOwner,
    )) {
      await LogHelper.writeLog(
        'SECURITY: Unauthorized delete attempt by $authorId',
        source: 'log_controller.dart',
        level: 1,
      );
      return;
    }

    await _box.deleteAt(index);
    currentLogs.removeAt(index);
    logsNotifier.value = currentLogs;
    // filteredLogs.value = currentLogs;

    try {
      if (targetLog.id == null) {
        throw Exception(
          'ID Log tidak ditemukan, tidak bisa menghapus di Cloud.',
        );
      }

      await MongoService().deleteLog(targetLog.id!);

      await LogHelper.writeLog(
        "SUCCESS: Sinkronisasi Hapus '${targetLog.title}' Berhasil",
        source: 'log_controller.dart',
        level: 2,
      );
    } catch (e) {
      await LogHelper.writeLog(
        'ERROR: Gagal sinkronisasi Hapus - $e',
        source: 'log_controller.dart',
        level: 1,
      );
    }
  }

  void searchLog(String query) {
    if (query.isEmpty) {
      filteredLogs.value = logsNotifier.value;
    } else {
      filteredLogs.value = logsNotifier.value.where((log) {
        bool searchTitle = log.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        bool searchDesc = log.description.toLowerCase().contains(
          query.toLowerCase(),
        );
        return searchTitle || searchDesc;
      }).toList();
    }
  }

  void loadOfflineLogs() {
    final logs = _box.values.toList();
    logsNotifier.value = logs;
    // filteredLogs.value = logs;
  }

  Future<void> loadLogs() async {
    loadOfflineLogs();

    try {
      final cloudData = await MongoService().getLogs(teamId);

      await _box.clear();
      await _box.addAll(cloudData);

      logsNotifier.value = cloudData;
      // filteredLogs.value = cloudData;

      await LogHelper.writeLog(
        'SYNC: Data berhasil diperbarui dari MongoDB',
        level: 2,
      );
    } catch (e) {
      await LogHelper.writeLog(
        'OFFLINE: Menggunakan data cache lokal',
        level: 2,
      );
    }
  }
}
