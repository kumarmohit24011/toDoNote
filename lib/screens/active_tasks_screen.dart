
import 'package:flutter/material.dart';
import '../widgets/task_list.dart';

class ActiveTasksScreen extends StatelessWidget {
  const ActiveTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tasks'),
      ),
      body: const TaskList(
        isCompletedTasks: false,
        sortAscending: true,
      ),
    );
  }
}
