
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../services/notification_service.dart';
import 'dart:developer' as developer;

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    _tasks.sort((a, b) {
      if (a.isImportant && !b.isImportant) {
        return -1;
      } else if (!a.isImportant && b.isImportant) {
        return 1;
      } else {
        return 0;
      }
    });
    return _tasks;
  }

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

  void addTask(String title, DateTime? dueDate, bool isImportant) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      dueDate: dueDate,
      isImportant: isImportant,
    );
    _tasks.add(newTask);
    if (dueDate != null) {
      developer.log('Attempting to schedule notification for new task: ${newTask.title}', name: 'TaskProvider');
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

  void toggleTaskImportance(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isImportant = !_tasks[taskIndex].isImportant;
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

  void editTask(String id, String newTitle, DateTime? newDueDate, bool isImportant) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final oldTask = _tasks[taskIndex];

      // Cancel old notification if due date exists
      if (oldTask.dueDate != null) {
        NotificationService().cancelNotification(oldTask.id.hashCode);
      }

      // Update task details
      _tasks[taskIndex].title = newTitle;
      _tasks[taskIndex].dueDate = newDueDate;
      _tasks[taskIndex].isImportant = isImportant;

      // Schedule new notification if new due date exists
      if (newDueDate != null) {
        NotificationService().scheduleNotification(oldTask.id.hashCode, newTitle, newDueDate);
      }

      saveTasks();
      notifyListeners();
    }
  }
}
