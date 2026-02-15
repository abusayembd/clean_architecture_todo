//Domain Code (Entity)
import 'package:equatable/equatable.dart';

class TodoTask extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  const TodoTask({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  TodoTask copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted, createdAt];
}
