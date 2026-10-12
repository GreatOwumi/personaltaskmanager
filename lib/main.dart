import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'models/task.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // On desktop we must switch sqflite to the FFI version.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Temporary test: save a task, then read all tasks back.
  final service = DatabaseService();
  await service.insertTask(
    Task(title: 'Test task', dueDate: DateTime.now()),
  );
  final tasks = await service.getTasks();
  print('Tasks in database: ${tasks.length}');

  runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('DB test')))));
}