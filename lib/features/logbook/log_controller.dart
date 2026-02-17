import 'package:logbook_app_080/features/logbook/models/log_model.dart';

class LogController {
  final List<LogModel> _logs = [];
  List<LogModel> get logs => _logs;

  void addLog(String title, String desc) {
    final newLog = LogModel(
      title: title,
      description: desc,
      date: DateTime.now().toString(),
    );
    _logs.add(newLog);
  }

  void updateLog(int index, String title, String desc) {
    _logs[index] = LogModel(
      title: title,
      description: desc,
      date: DateTime.now().toString(),
    );
  }

  void removeLog(int index) {
    _logs.removeAt(index);
  }
}
