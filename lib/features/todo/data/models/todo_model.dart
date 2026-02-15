import 'package:clean_todo/features/todo/data/datasources/todo_db_helper.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';

class TodoModel extends TodoTask {
  const TodoModel({
    super.id,
    required super.title,
    super.description,
    required super.isCompleted,
    required super.createdAt,
    super.priority = TodoPriority.medium,
    super.dueDate,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map[TodoDbHelper.colId] as int?,
      title: map[TodoDbHelper.colTitle] as String,
      description: map[TodoDbHelper.colDescription] as String?,
      isCompleted: (map[TodoDbHelper.colIsCompleted] as int) == 1,
      createdAt: DateTime.parse(map[TodoDbHelper.colCreatedAt] as String),
      priority:
          TodoPriority.values[(map[TodoDbHelper.colPriority] as int?) ?? 1],
      dueDate: (map[TodoDbHelper.colDueDate] as String?) == null
          ? null
          : DateTime.parse(map[TodoDbHelper.colDueDate] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TodoDbHelper.colId: id,
      TodoDbHelper.colTitle: title,
      TodoDbHelper.colDescription: description,
      TodoDbHelper.colIsCompleted: isCompleted ? 1 : 0,
      TodoDbHelper.colCreatedAt: createdAt.toIso8601String(),
      TodoDbHelper.colPriority: priority.index,
      TodoDbHelper.colDueDate: dueDate?.toIso8601String(),
    };
  }

  TodoTask toEntity() {
    return TodoTask(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      priority: priority,
      dueDate: dueDate,
    );
  }

  factory TodoModel.fromEntity(TodoTask task) {
    return TodoModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      priority: task.priority,
      dueDate: task.dueDate,
    );
  }
}
