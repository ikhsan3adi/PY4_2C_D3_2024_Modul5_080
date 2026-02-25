import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logbook_app_080/constants/app_constants.dart';
import 'package:logbook_app_080/features/logbook/models/log_model.dart';
import 'package:logbook_app_080/helpers/date_helper.dart';

class LogDetailView extends StatelessWidget {
  final LogModel log;
  final bool canEdit;
  final VoidCallback? onEditPressed;

  const LogDetailView({
    super.key,
    required this.log,
    this.canEdit = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final categoryIcon = AppConstants.categoryIcons[log.category] ?? Icons.note;
    final accentColor =
        AppConstants.categoryAccentColors[log.category] ?? theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: canEdit && onEditPressed != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Catatan',
                  onPressed: onEditPressed,
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: accentColor.withValues(alpha: 0.1),
                  avatar: Icon(categoryIcon, size: 16, color: accentColor),
                  label: Text(
                    log.category,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    DateHelper.formatTimestamp(log.timestamp),
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              log.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Oleh: ${log.authorId}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.group_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Tim: ${log.teamId}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(),
            ),

            MarkdownBody(
              data: log.description,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                h1: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                h2: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                blockquote: const TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: accentColor, width: 4),
                  ),
                  color: accentColor.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
