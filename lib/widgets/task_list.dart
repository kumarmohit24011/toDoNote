
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_list_item.dart';

class TaskList extends StatelessWidget {
  final bool isCompletedTasks;

  const TaskList({super.key, required this.isCompletedTasks});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = isCompletedTasks
        ? taskProvider.tasks.where((task) => task.isCompleted).toList()
        : taskProvider.tasks.where((task) => !task.isCompleted).toList();

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompletedTasks ? Icons.check_circle_outline : Icons.list_alt_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isCompletedTasks ? 'No completed tasks' : 'No pending tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(task: task);
      },
    );
  }
}
