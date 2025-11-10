
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];
    _tasks = taskList.map((json) => Task.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void addTask(String title, [DateTime? dueDate]) {
    final newTask = Task(id: DateTime.now().toString(), title: title, dueDate: dueDate);
    _tasks.add(newTask);
    if (dueDate != null) {
      NotificationService().scheduleNotification(newTask.id.hashCode, newTask.title, dueDate);
    }
    saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      final task = _tasks[taskIndex];
      if (task.isCompleted && task.dueDate != null) {
        NotificationService().cancelNotification(task.id.hashCode);
      }
      saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      if (task.dueDate != null) {
        NotificationService().cancelNotification(task.id.hashCode);
      }
      _tasks.removeAt(taskIndex);
      saveTasks();
      notifyListeners();
    }
  }
}
