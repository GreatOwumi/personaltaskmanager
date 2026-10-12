import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

// This class is the only place that talks to the database.
class DatabaseService {
  Database? _database;

  // Opens the database the first time, then reuses it.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final folder = await getDatabasesPath();
    final path = join(folder, 'tasks.db');

    return openDatabase(
      path,
      version: 1,
      // Runs only once, when the database file is first created.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            due_date TEXT NOT NULL,
            priority TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Create: saves a new task.
  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  // Read: gets all tasks, earliest due date first.
  Future<List<Task>> getTasks() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'due_date ASC');
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  // Update: saves changes to an existing task.
  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete: removes a task by its id.
  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}