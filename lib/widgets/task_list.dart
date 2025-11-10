import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskList extends StatelessWidget {
  final bool isCompletedTasks;

  const TaskList({super.key, required this.isCompletedTasks});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = isCompletedTasks
        ? taskProvider.tasks.where((task) => task.isCompleted).toList()
        : taskProvider.tasks.where((task) => !task.isCompleted).toList();

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) => taskProvider.toggleTaskStatus(task.id),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => taskProvider.deleteTask(task.id),
          ),
        );
      },
    );
  }
}
