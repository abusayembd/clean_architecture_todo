//Domain Code (Entity)
import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high }

class TodoTask extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final TodoPriority priority;
  final DateTime? dueDate;

  const TodoTask({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.priority = TodoPriority.medium,
    this.dueDate,
  });

  TodoTask copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    TodoPriority? priority,
    DateTime? dueDate,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt, priority, dueDate];
}
