import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PreviewTab extends StatelessWidget {
  final String markdownText;

  const PreviewTab({super.key, required this.markdownText});

  @override
  Widget build(BuildContext context) {
    if (markdownText.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.preview,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Ketik sesuatu di tab Editor\nuntuk melihat pratinjau Markdown',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ],
        ),
      );
    }

    return Markdown(
      data: markdownText,
      selectable: true,
      padding: const EdgeInsets.all(16),
    );
  }
}
