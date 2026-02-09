import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CounterController {
  int _counter = 0;
  int get value => _counter;

  int _step = 1;
  int get step => _step;

  final List<(String, String, Color?)> _history = [];
  List<(String, String, Color?)> get history => _history;

  void increment() {
    _counter += _step;

    addHistory(
      'User menambah nilai sebesar $_step. Hitungan: $_counter',
      Colors.green[100],
    );
  }

  void decrement() {
    if (_counter > 0) {
      _counter = max(_counter - _step, 0);

      addHistory(
        'User mengurangi nilai sebesar $_step. Hitungan: $_counter',
        Colors.red[100],
      );
    }
  }

  void reset() {
    _counter = 0;
    _step = 1;
    _history.clear();

    addHistory('User mereset nilai. Hitungan: $_counter', Colors.purple[100]);
  }

  void setStep(int step) {
    if (step > 0) {
      _step = step;

      addHistory('User mengubah step menjadi $_step', Colors.lightBlue[100]);
    }
  }

  void addHistory(String msg, Color? color) {
    final time = DateTime.now();
    final timeString = DateFormat('d MMM yyyy hh:mm:ss').format(time);

    _history.add((timeString, msg, color));

    if (_history.length > 5) _history.removeAt(0);
  }
}
