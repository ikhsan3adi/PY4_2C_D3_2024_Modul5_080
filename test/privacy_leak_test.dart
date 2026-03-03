import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:logbook_app_080/features/logbook/log_controller.dart';
import 'package:logbook_app_080/features/logbook/models/log_model.dart';
import 'package:logbook_app_080/services/mongo_service.dart';
import 'package:mocktail/mocktail.dart';

class MockMongoService extends Mock implements MongoService {}

void main() {
  group('Privacy Leak Test (HOTS)', () {
    final userAId = 'user_a_id';
    final userBId = 'user_b_id';
    final teamId = 'MEKTRA_KLP_01';

    // User A memiliki 2 catatan (1 Private, 1 Public)
    final privatLog = LogModel(
      id: 'log_001',
      username: 'user_a',
      title: 'Rahasia User A',
      description: 'Ini private',
      timestamp: DateTime.now().toString(),
      category: 'Pribadi',
      authorId: userAId,
      teamId: teamId,
      isPublic: false,
    );

    final publicLog = LogModel(
      id: 'log_002',
      username: 'user_a',
      title: 'Publik User A',
      description: 'Ini public',
      timestamp: DateTime.now().toString(),
      category: 'Proyek',
      authorId: userAId,
      teamId: teamId,
      isPublic: true,
    );

    final mockCloudData = [privatLog, publicLog];

    setUpAll(() async {
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      Hive.registerAdapter(LogModelAdapter());
      await Hive.openBox<LogModel>('offline_logs');
    });

    tearDownAll(() async {
      await Hive.close();
      await Hive.deleteFromDisk();
    });

    setUp(() async {
      final box = Hive.box<LogModel>('offline_logs');
      await box.clear();
      await box.addAll(mockCloudData);
    });

    test(
      'RBAC Security Check: Private logs should NOT be visible to teammates',
      () async {
        // Action
        // User B melakukan inisialisasi LogController
        final controllerUserB = LogController(
          username: 'user_b',
          authorId: userBId,
          teamId: teamId,
          userRole: 'Anggota',
        );

        // mensimulasikan perilaku loadLogs
        controllerUserB.logsNotifier.value = mockCloudData;

        // searchLog('') otomatis mengeksekusi getVisibleLogs()
        controllerUserB.searchLog('');

        // Assert
        final resultList = controllerUserB.filteredLogs.value;

        expect(
          resultList.length,
          1,
          reason: 'Seharusnya hanya ada 1 log yang visible untuk User B',
        );
        expect(
          resultList.first.isPublic,
          true,
          reason: 'Log yang visible harus berstatus Public',
        );
        expect(
          resultList.first.title,
          'Publik User A',
          reason: 'Log yang visible harus milik User A yang Public',
        );

        controllerUserB.dispose();
      },
    );
  });
}
