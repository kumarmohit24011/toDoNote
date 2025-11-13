import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';

class ActiveTasksScreen extends StatelessWidget {
  const ActiveTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final activeTasks = taskProvider.tasks.where((task) => !task.isCompleted).toList();
          return TaskList(tasks: activeTasks);
        },
      ),
    );
  }
}
