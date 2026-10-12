import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'models/task.dart';
import 'provider/task_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // On desktop we must switch sqflite to the FFI version.
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    // Puts one TaskProvider at the top and loads the tasks at start.
    ChangeNotifierProvider(
      create: (context) => TaskProvider()..loadTasks(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Personal Task Manager',
      home: TestScreen(),
    );
  }
}

// Temporary screen to check that Provider works.
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: this screen rebuilds when the provider changes.
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Task Manager')),
      body: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : Text('Tasks: ${provider.tasks.length}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // read: we only call a method here, no rebuild needed.
          context.read<TaskProvider>().addTask(
                Task(title: 'Another test', dueDate: DateTime.now()),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}