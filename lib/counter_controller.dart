import 'dart:math';

class CounterController {
  int _counter = 0;
  int get value => _counter;

  int _step = 1;
  int get step => _step;

  void increment() => _counter += _step;

  void decrement() {
    if (_counter > 0) {
      _counter = max(_counter - _step, 0);
    }
  }

  void reset() {
    _counter = 0;
    _step = 1;
  }

  void setStep(int step) {
    if (step > 0) {
      _step = step;
    }
  }
}
