import 'dart:async';

import 'package:flutter/foundation.dart';

class LoginController {
  // Database user: username -> {password, role, authorId}
  final Map<String, Map<String, String>> _users = {
    'admin': {'password': '123', 'role': 'Ketua', 'authorId': 'admin_001'},
    'satriadi': {
      'password': '123',
      'role': 'Anggota',
      'authorId': 'satriadi_080',
    },
    'user': {'password': 'user', 'role': 'Anggota', 'authorId': 'user_002'},
  };

  static const String defaultTeamId = 'MEKTRA_KLP_01';

  int _failedAttempts = 0;
  final ValueNotifier<bool> isLocked = ValueNotifier(false);
  Timer? _lockoutTimer;

  bool login(String username, String password) {
    if (isLocked.value) return false;

    final user = _users[username];
    if (user != null && user['password'] == password) {
      _resetLockout();
      return true;
    } else {
      _handleFailedAttempt();
      return false;
    }
  }

  /// Ambil data profil user setelah login berhasil
  Map<String, String>? getUserData(String username) {
    final user = _users[username];
    if (user == null) return null;

    return {
      'username': username,
      'role': user['role'] ?? 'Anggota',
      'authorId': user['authorId'] ?? username,
      'teamId': defaultTeamId,
    };
  }

  void _handleFailedAttempt() {
    _failedAttempts++;
    if (_failedAttempts >= 3) {
      isLocked.value = true;
      _lockoutTimer = Timer(const Duration(seconds: 10), () {
        _resetLockout();
      });
    }
  }

  void _resetLockout() {
    _failedAttempts = 0;
    isLocked.value = false;
    _lockoutTimer?.cancel();
  }

  void dispose() {
    _lockoutTimer?.cancel();
    isLocked.dispose();
  }
}
