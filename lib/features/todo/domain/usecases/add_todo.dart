import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo_task.dart';
import '../repositories/todo_repository.dart';

class AddTodo implements UseCase<Either<Failure, TodoTask>, TodoTask> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<Either<Failure, TodoTask>> call(TodoTask params) {
    return repository.addTodo(params);
  }
}