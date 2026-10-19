import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
            },
            onDelete: () => context.read<TaskProvider>().deleteTask(task.id!),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Task Manager')),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}