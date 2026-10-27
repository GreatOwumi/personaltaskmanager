import 'package:flutter/material.dart';

import '../models/task.dart';

// Shows one task as a card.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<TaskStatus> onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onStatusChanged,
  });

  // The colour strip on the left shows the priority.
  Color _priorityColor() {
    switch (task.priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _priorityText() {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  // The status badge has its own colour.
  Color _statusColor() {
    switch (task.status) {
      case TaskStatus.todo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  String _statusText() {
    switch (task.status) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  // A task is overdue if its date is before today and it is not completed.
  bool _isOverdue() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return task.status != TaskStatus.completed && task.dueDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final overdue = _isOverdue();
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    final date = task.dueDate;
    final dateText = '${date.day}/${date.month}/${date.year}';
    final dateColor = overdue ? Colors.red : mutedColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Priority colour strip.
              Container(width: 6, color: _priorityColor()),

              // Task details.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // Completed tasks are crossed out and dimmed.
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? mutedColor : null,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: mutedColor),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 14,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Due date (red if overdue).
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: dateColor),
                              const SizedBox(width: 4),
                              Text(
                                overdue ? '$dateText (overdue)' : dateText,
                                style: TextStyle(color: dateColor),
                              ),
                            ],
                          ),
                          // Priority label.
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flag,
                                  size: 14, color: _priorityColor()),
                              const SizedBox(width: 4),
                              Text(_priorityText()),
                            ],
                          ),
                          // Status badge.
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor().withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _statusText(),
                              style: TextStyle(
                                color: _statusColor(),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons on the right.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopupMenuButton<TaskStatus>(
                    icon: const Icon(Icons.swap_horiz),
                    tooltip: 'Change status',
                    onSelected: onStatusChanged,
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: TaskStatus.todo,
                        child: Text('To Do'),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.inProgress,
                        child: Text('In Progress'),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.completed,
                        child: Text('Completed'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}