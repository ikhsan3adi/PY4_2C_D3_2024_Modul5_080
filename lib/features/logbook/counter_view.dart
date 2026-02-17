import 'package:flutter/material.dart';
import 'package:logbook_app_080/features/logbook/counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('LogBook: SRP'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: Column(
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
              FilledButton.icon(
                icon: Icon(Icons.rotate_left),
                onPressed: () async {
                  if (await _showResetDialog(context) ?? false) {
                    setState(() => _controller.reset());
                  }
                },
                label: Text('Reset'),
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
              Divider(indent: 16, endIndent: 16),
              Text('Riwayat'),
              if (_controller.history.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Belum Ada Riwayat',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.disabledColor),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      ..._controller.history.reversed.map(
                        (e) => Card(
                          color: e.$3,
                          child: ListTile(
                            leading: Icon(Icons.history_sharp),
                            title: Text(e.$1),
                            subtitle: Text(e.$2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showResetDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Reset'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua riwayat hitungan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hitungan telah direset')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
