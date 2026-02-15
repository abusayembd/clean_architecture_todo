import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo_task.dart';
import '../repositories/todo_repository.dart';

class UpdateTodo implements UseCase<Either<Failure, TodoTask>, TodoTask> {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  @override
  Future<Either<Failure, TodoTask>> call(TodoTask params) {
    return repository.updateTodo(params);
  }
}