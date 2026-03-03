import 'package:flutter/material.dart';

class AppConstants {
  // database
  static const Duration connectionTimeout = Duration(seconds: 15);

  static const List<String> categories = [
    'Pribadi',
    'Pekerjaan',
    'Urgent',
    'Mechanical',
    'Electronic',
    'Software',
  ];

  static const Map<String, Color> categoryColors = {
    'Pribadi': Color(0xFFBBDEFB),
    'Pekerjaan': Color(0xFFE1BEE7),
    'Urgent': Color(0xFFFFCDD2),
    'Mechanical': Color(0xFFC8E6C9),
    'Electronic': Color(0xFFB3E5FC),
    'Software': Color(0xFFFFF9C4),
  };

  static const Map<String, Color> categoryAccentColors = {
    'Pribadi': Color(0xFF0D47A1),
    'Pekerjaan': Color(0xFF4A148C),
    'Urgent': Color(0xFFB71C1C),
    'Mechanical': Color(0xFF1B5E20),
    'Electronic': Color(0xFF01579B),
    'Software': Color(0xFFF57F17),
  };

  static const Map<String, IconData> categoryIcons = {
    'Pribadi': Icons.person,
    'Pekerjaan': Icons.work,
    'Urgent': Icons.priority_high,
    'Mechanical': Icons.settings,
    'Electronic': Icons.memory,
    'Software': Icons.code,
  };
}
