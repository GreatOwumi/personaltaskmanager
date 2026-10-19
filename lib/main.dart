import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'provider/task_provider.dart';
import 'screens/task_list_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Task Manager',
      // Light theme, built from one seed colour.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      // Dark theme, used when Windows is set to dark mode.
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TaskListScreen(),
    );
  }
}