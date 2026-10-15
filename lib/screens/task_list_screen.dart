import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../provider/task_provider.dart';
import '../widgets/task_card.dart';

// The main screen: shows all tasks.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: this screen rebuilds when the provider changes.
    final provider = context.watch<TaskProvider>();

    Widget body;
    if (provider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.tasks.isEmpty) {
      body = const Center(child: Text('No tasks yet. Tap + to add one.'));
    } else {
      body = ListView.builder(
        itemCount: provider.tasks.length,
        itemBuilder: (context, index) {
          final task = provider.tasks[index];
          return TaskCard(
            task: task,
            onDelete: () => context.read<TaskProvider>().deleteTask(task.id!),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Task Manager')),
      body: body,
      floatingActionButton: FloatingActionButton(
        // Temporary: adds a sample task. We build the real form in Stage 5.
        onPressed: () {
          context.read<TaskProvider>().addTask(
                Task(
                  title: 'Sample task',
                  description: 'Added with the + button',
                  dueDate: DateTime.now(),
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}