import 'package:dartz/dartz.dart';

import 'package:clean_todo/core/error/failures.dart';
import 'package:clean_todo/core/usecase/usecase.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';
import 'package:clean_todo/features/todo/domain/repositories/todo_repository.dart';

class GetAllTodos
    implements UseCase<Either<Failure, List<TodoTask>>, NoParams> {
  final TodoRepository repository;

  GetAllTodos(this.repository);

  @override
  Future<Either<Failure, List<TodoTask>>> call(NoParams params) {
    return repository.getAllTodos();
  }
}
