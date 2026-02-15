import 'package:dartz/dartz.dart';

import 'package:clean_todo/core/error/failures.dart';
import 'package:clean_todo/core/usecase/usecase.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';
import 'package:clean_todo/features/todo/domain/repositories/todo_repository.dart';

class UpdateTodo implements UseCase<Either<Failure, TodoTask>, TodoTask> {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  @override
  Future<Either<Failure, TodoTask>> call(TodoTask params) {
    return repository.updateTodo(params);
  }
}
