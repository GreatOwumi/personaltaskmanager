import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/database_service.dart';

// Holds the list of tasks and tells the screens when it changes.
class TaskProvider extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Screens read these. They cannot change them directly.
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Loads all tasks from the database.
  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _service.getTasks();
    } catch (e) {
      _errorMessage = 'Could not load tasks.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Saves a new task, then reloads the list.
  Future<void> addTask(Task task) async {
    try {
      await _service.insertTask(task);
      await loadTasks();
    } catch (e) {
      _errorMessage = 'Could not add task.';
      notifyListeners();
    }
  }

  // Saves changes to a task, then reloads the list.
  Future<void> updateTask(Task task) async {
    try {
      await _service.updateTask(task);
      await loadTasks();
    } catch (e) {
      _errorMessage = 'Could not update task.';
      notifyListeners();
    }
  }

  // Deletes a task, then reloads the list.
  Future<void> deleteTask(int id) async {
    try {
      await _service.deleteTask(id);
      await loadTasks();
    } catch (e) {
      _errorMessage = 'Could not delete task.';
      notifyListeners();
    }
  }
}