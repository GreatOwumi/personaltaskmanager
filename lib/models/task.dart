// The three states a task can be in.
enum TaskStatus { todo, inProgress, completed }
// How important a task is.
enum TaskPriority { low, medium, high }

//A task holds all the information about one to-do item
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
  });

  //Makes a copy of this task with some fields changed.
  // Fields are final, so we copy instead of editing.
  Task copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  //Turns a Task into a Map so it can be saved in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
    };
  }

  // Turns a Map from the database back into a Task
  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['due_date'] as String),
      priority: TaskPriority.values.byName(map['priority'] as String),
      status: TaskStatus.values.byName(map['status'] as String),
    );
  }
}