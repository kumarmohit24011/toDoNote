import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) => taskProvider.toggleTask(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text('Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.isImportant ? Icons.star : Icons.star_border,
                color: task.isImportant ? Colors.amber : null,
              ),
              onPressed: () => taskProvider.toggleImportant(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => taskProvider.deleteTask(task),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              task: task,
              onAddTask: (title, dueDate, isImportant) {
                taskProvider.editTask(task, title, dueDate, isImportant);
              },
            ),
          );
        },
      ),
    );
  }
}
