// TodoModel (Data Layer)
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';

class TodoModel extends TodoTask {
  const TodoModel({
    super.id,
    required super.title,
    super.description,
    required super.isCompleted,
    required super.createdAt,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    final isCompletedValue = map['is_completed'];
    return TodoModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['desscription'] as String?,
      isCompleted:
          (isCompletedValue == null ? 0 : isCompletedValue as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TodoTask toEntity() {
    return TodoTask(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  factory TodoModel.fromEntity(TodoTask task) {
    return TodoModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );
  }
}
