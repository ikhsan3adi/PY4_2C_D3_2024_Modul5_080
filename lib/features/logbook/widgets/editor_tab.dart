import 'package:flutter/material.dart';
import 'package:logbook_app_080/constants/app_constants.dart';

class EditorTab extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const EditorTab({
    super.key,
    required this.titleController,
    required this.descController,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Judul',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: AppConstants.categories
                .map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(
                          AppConstants.categoryIcons[cat],
                          size: 16,
                          color: AppConstants.categoryAccentColors[cat],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cat,
                          style: TextStyle(
                            color: AppConstants.categoryAccentColors[cat],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onCategoryChanged(value);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: descController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText:
                    'Tulis laporan dengan format Markdown...\n\n'
                    '# Heading\n'
                    '**bold** *italic*\n'
                    '- list item\n'
                    '`inline code`',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
