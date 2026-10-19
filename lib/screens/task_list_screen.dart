import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../provider/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

// The main screen: shows all tasks.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  // One filter chip. A null status means "All".
  Widget _filterChip(
    BuildContext context,
    String label,
    TaskStatus? status,
  ) {
    final provider = context.watch<TaskProvider>();

    return ChoiceChip(
      label: Text(label),
      selected: provider.statusFilter == status,
      onSelected: (_) {
        context.read<TaskProvider>().setStatusFilter(status);
      },
    );
  }

  // Shows a red message if the last action failed.
  // If it worked, shows the success message (when there is one).
  void _showResult(
    ScaffoldMessengerState messenger,
    TaskProvider provider,
    String? successMessage,
  ) {
    final error = provider.errorMessage;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else if (successMessage != null) {
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    }
  }

  // Asks the user to confirm, then deletes the task.
  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final provider = context.read<TaskProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be deleted for good.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Anything other than "Delete" means do nothing.
    if (confirmed != true) return;

    await provider.deleteTask(task.id!);
    _showResult(messenger, provider, 'Task deleted');
  }

  // Changes a task's status from the card menu.
  Future<void> _changeStatus(
    BuildContext context,
    Task task,
    TaskStatus newStatus,
  ) async {
    final provider = context.read<TaskProvider>();
    final messenger = ScaffoldMessenger.of(context);

    await provider.updateTask(task.copyWith(status: newStatus));
    _showResult(messenger, provider, null);
  }

  @override
  Widget build(BuildContext context) {
    // watch: this screen rebuilds when the provider changes.
    final provider = context.watch<TaskProvider>();
    final tasks = provider.filteredTasks;

    Widget body;
    if (provider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (tasks.isEmpty) {
      body = const Center(child: Text('No tasks found.'));
    } else {
      body = ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
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
            onStatusChanged: (newStatus) {
              _changeStatus(context, task, newStatus);
            },
            onDelete: () => _confirmDelete(context, task),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Task Manager')),
      body: Column(
        children: [
          // Search box.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                context.read<TaskProvider>().setSearchText(text);
              },
            ),
          ),
          // Status filter chips.
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                _filterChip(context, 'All', null),
                _filterChip(context, 'To Do', TaskStatus.todo),
                _filterChip(context, 'In Progress', TaskStatus.inProgress),
                _filterChip(context, 'Completed', TaskStatus.completed),
              ],
            ),
          ),
          // The list takes the rest of the space.
          Expanded(child: body),
        ],
      ),
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