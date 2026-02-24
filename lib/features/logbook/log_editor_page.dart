import 'package:flutter/material.dart';
import 'package:logbook_app_080/constants/app_constants.dart';
import 'package:logbook_app_080/features/logbook/log_controller.dart';
import 'package:logbook_app_080/features/logbook/models/log_model.dart';
import 'package:logbook_app_080/features/logbook/widgets/editor_tab.dart';
import 'package:logbook_app_080/features/logbook/widgets/preview_tab.dart';

class LogEditorPage extends StatefulWidget {
  final LogModel? log;
  final int? index;
  final LogController controller;
  final Map<String, String> currentUser;

  const LogEditorPage({
    super.key,
    this.log,
    this.index,
    required this.controller,
    required this.currentUser,
  });

  @override
  State<LogEditorPage> createState() => _LogEditorPageState();
}

class _LogEditorPageState extends State<LogEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedCategory;

  bool get _isEditing => widget.log != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.log?.title ?? '');
    _descController = TextEditingController(
      text: widget.log?.description ?? '',
    );
    _selectedCategory = widget.log?.category ?? AppConstants.categories.first;

    _descController.addListener(() => setState(() {}));
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul tidak boleh kosong'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_isEditing) {
      await widget.controller.updateLog(
        widget.index!,
        _titleController.text,
        _descController.text,
        category: _selectedCategory,
      );
    } else {
      await widget.controller.addLog(
        _titleController.text,
        _descController.text,
        category: _selectedCategory,
        authorId: widget.currentUser['authorId'],
        teamId: widget.currentUser['teamId'],
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Catatan' : 'Catatan Baru'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: 'Editor'),
              Tab(icon: Icon(Icons.preview), text: 'Pratinjau'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Simpan',
              onPressed: _save,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            EditorTab(
              titleController: _titleController,
              descController: _descController,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            PreviewTab(markdownText: _descController.text),
          ],
        ),
      ),
    );
  }
}
