import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class LogHelper {
  static Future<void> writeLog(
    String message, {
    String source = 'Unknown',
    int level = 2,
  }) async {
    final int configLevel = int.tryParse(dotenv.env['LOG_LEVEL'] ?? '2') ?? 2;
    final String muteList = dotenv.env['LOG_MUTE'] ?? '';

    if (level > configLevel) return;
    if (muteList.split(',').contains(source)) return;

    try {
      String timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
      String label = _getLabel(level);
      String color = _getColor(level);

      dev.log(message, name: source, time: DateTime.now(), level: level * 100);

      // ignore: avoid_print
      print('$color[$timestamp][$label][$source] -> $message\x1B[0m');

      // Tulis ke file log harian
      await _writeToFile('[$timestamp][$label][$source] -> $message');
    } catch (e) {
      dev.log('Logging failed: $e', name: 'SYSTEM', level: 1000);
    }
  }

  static Future<void> _writeToFile(String logLine) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final logFile = File('${logDir.path}/$dateStr.log');

      await logFile.writeAsString('$logLine\n', mode: FileMode.append);
    } catch (e) {
      dev.log('File logging failed: $e', name: 'SYSTEM', level: 1000);
    }
  }

  static String _getLabel(int level) {
    switch (level) {
      case 1:
        return 'ERROR';
      case 2:
        return 'INFO';
      case 3:
        return 'VERBOSE';
      default:
        return 'LOG';
    }
  }

  static String _getColor(int level) {
    switch (level) {
      case 1:
        return '\x1B[31m';
      case 2:
        return '\x1B[32m';
      case 3:
        return '\x1B[34m';
      default:
        return '\x1B[0m';
    }
  }
}
