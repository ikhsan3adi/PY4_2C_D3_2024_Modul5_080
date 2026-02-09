import 'package:flutter/material.dart';
import 'package:logbook_app_080/counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LogBook: SRP'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 16,
            children: [
              Text('Total Hitungan'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  IconButton.filled(
                    onPressed: () => setState(() => _controller.decrement()),
                    icon: Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  Text(
                    _controller.value.toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  IconButton.filled(
                    onPressed: () => setState(() => _controller.increment()),
                    icon: Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
              Divider(indent: 16, endIndent: 16),
              Text('Step / Langkah: ${_controller.step}'),
              Slider(
                value: _controller.step.toDouble(),
                onChanged: (value) => setState(() {
                  _controller.setStep(value.toInt());
                }),
                min: 1,
                max: 10,
                divisions: 9,
                label: 'Step',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
