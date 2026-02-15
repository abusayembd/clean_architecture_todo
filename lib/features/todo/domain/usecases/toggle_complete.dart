import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo_task.dart';
import '../repositories/todo_repository.dart';

class ToggleComplete implements UseCase<Either<Failure, TodoTask>, int> {
  final TodoRepository repository;

  ToggleComplete(this.repository);

  @override
  Future<Either<Failure, TodoTask>> call(int params) {
    return repository.toggleComplete(params);
  }
}