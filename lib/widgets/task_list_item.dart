
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'add_task_dialog.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: task.isImportant ? 4.0 : 1.0,
      shape: task.isImportant
          ? RoundedRectangleBorder(
              side: BorderSide(color: Colors.amber.shade700, width: 2),
              borderRadius: BorderRadius.circular(12),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            taskProvider.toggleTaskStatus(task.id);
          },
          activeColor: colorScheme.primary,
        ),
        title: Text(
          task.title,
          style: textTheme.titleMedium?.copyWith(
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : textTheme.titleMedium?.color,
          ),
        ),
        subtitle: task.dueDate != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: colorScheme.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('MMM d, yyyy, h:mm a').format(task.dueDate!),
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.isImportant ? Icons.star : Icons.star_border,
                color: task.isImportant ? Colors.amber.shade700 : colorScheme.secondary,
              ),
              onPressed: () {
                taskProvider.toggleTaskImportance(task.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddTaskDialog(
                    task: task,
                    onAddTask: (title, dueDate, isImportant) {
                      if (dueDate != null &&
                          !dueDate.isAtSameMomentAs(task.dueDate ?? DateTime(0)) &&
                          dueDate.isBefore(DateTime.now())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot schedule a task for a past date.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      taskProvider.editTask(task.id, title, dueDate, isImportant);
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: () {
                taskProvider.deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
