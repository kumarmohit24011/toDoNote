import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final User? _user;
  DatabaseReference? _tasksRef;

  List<Task> _tasks = [];

  TaskProvider(this._user) {
    if (_user != null) {
      _tasksRef = FirebaseDatabase.instance.ref('tasks/${_user!.uid}');
      _listenToTasks();
    }
  }

  List<Task> get tasks => _tasks;

  void _listenToTasks() {
    _tasksRef?.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _tasks = data.entries.map((entry) {
          final taskData = entry.value as Map<dynamic, dynamic>;
          return Task(
            id: entry.key,
            title: taskData['title'] ?? '',
            isCompleted: taskData['isCompleted'] ?? false,
            dueDate: taskData['dueDate'] != null
                ? DateTime.parse(taskData['dueDate'])
                : null,
            isImportant: taskData['isImportant'] ?? false,
          );
        }).toList();
      } else {
        _tasks = [];
      }
      notifyListeners();
    });
  }

  void addTask(String title, DateTime? dueDate, bool isImportant) {
    if (_tasksRef != null) {
      final newTaskRef = _tasksRef!.push();
      newTaskRef.set({
        'title': title,
        'isCompleted': false,
        'dueDate': dueDate?.toIso8601String(),
        'isImportant': isImportant,
      });
    }
  }

  void toggleTask(Task task) {
    if (_tasksRef != null) {
      _tasksRef!.child(task.id).update({
        'isCompleted': !task.isCompleted,
      });
    }
  }

  void deleteTask(Task task) {
    if (_tasksRef != null) {
      _tasksRef!.child(task.id).remove();
    }
  }
}
