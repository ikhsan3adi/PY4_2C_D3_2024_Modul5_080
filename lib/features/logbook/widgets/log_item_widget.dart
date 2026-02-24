import 'package:flutter/material.dart';
import 'package:logbook_app_080/constants/app_constants.dart';
import 'package:logbook_app_080/features/logbook/models/log_model.dart';
import 'package:logbook_app_080/helpers/date_helper.dart';

class LogItemWidget extends StatelessWidget {
  const LogItemWidget({
    super.key,
    required this.log,
    this.canEdit = true,
    this.canDelete = true,
    this.swipeToLeftAction,
    this.swipeToRightAction,
    this.afterSwipeToLeft,
    this.afterSwipeToRight,
    this.editAction,
    this.deleteAction,
  });

  final LogModel log;
  final bool canEdit;
  final bool canDelete;
  final Future<bool?> Function()? swipeToLeftAction;
  final Future<bool?> Function()? swipeToRightAction;
  final Function? afterSwipeToLeft;
  final Function? afterSwipeToRight;
  final Function(LogModel)? editAction;
  final Function(LogModel)? deleteAction;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final cardColor =
        AppConstants.categoryColors[log.category] ?? theme.cardColor;
    final categoryIcon = AppConstants.categoryIcons[log.category] ?? Icons.note;
    final accentColor =
        AppConstants.categoryAccentColors[log.category] ?? Colors.black;

    // Tentukan arah swipe berdasar izin RBAC
    final DismissDirection dismissDirection;
    if (canEdit && canDelete) {
      dismissDirection = DismissDirection.horizontal;
    } else if (canDelete) {
      dismissDirection = DismissDirection.endToStart;
    } else if (canEdit) {
      dismissDirection = DismissDirection.startToEnd;
    } else {
      dismissDirection = DismissDirection.none;
    }

    return Dismissible(
      key: Key(log.id ?? log.timestamp),
      direction: dismissDirection,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await swipeToLeftAction?.call();
        } else if (direction == DismissDirection.startToEnd) {
          return await swipeToRightAction?.call();
        }
        return null;
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await afterSwipeToLeft?.call();
        } else if (direction == DismissDirection.startToEnd) {
          await afterSwipeToRight?.call();
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 4),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: Icon(categoryIcon, color: accentColor),
          title: Text(
            log.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log.description),
              const SizedBox(height: 4),
              Row(
                children: [
                  Chip(
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                    avatar: Icon(categoryIcon, size: 14, color: accentColor),
                    label: Text(
                      log.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.cloud_done,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateHelper.formatTimestamp(log.timestamp),
                    style: TextStyle(fontSize: 11, color: theme.disabledColor),
                  ),
                ],
              ),
            ],
          ),
          isThreeLine: true,
          trailing: (canEdit || canDelete)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canEdit)
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editAction?.call(log),
                        ),
                      ),
                    if (canEdit && canDelete) const SizedBox(height: 8),
                    if (canDelete)
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteAction?.call(log),
                        ),
                      ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
