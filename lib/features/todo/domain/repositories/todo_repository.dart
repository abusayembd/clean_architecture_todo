import 'package:dartz/dartz.dart';

import 'package:clean_todo/core/error/failures.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoTask>>> getAllTodos();
  Future<Either<Failure, TodoTask>> addTodo(TodoTask task);
  Future<Either<Failure, TodoTask>> updateTodo(TodoTask task);
  Future<Either<Failure, void>> deleteTodo(int id);
  Future<Either<Failure, TodoTask>> toggleComplete(int id);
}
