import 'package:equatable/equatable.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final TodoTask task;

  const AddTodoEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTodoEvent extends TodoEvent {
  final TodoTask task;

  const UpdateTodoEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleCompleteEvent extends TodoEvent {
  final int id;

  const ToggleCompleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}
