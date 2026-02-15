import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/todo_task.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoTask>>> getAllTodos();
  Future<Either<Failure, TodoTask>> addTodo(TodoTask task);
  Future<Either<Failure, TodoTask>> updateTodo(TodoTask task);
  Future<Either<Failure, void>> deleteTodo(int id);
  Future<Either<Failure, TodoTask>> toggleComplete(int id);
}