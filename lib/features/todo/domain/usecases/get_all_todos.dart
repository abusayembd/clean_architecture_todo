import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo_task.dart';
import '../repositories/todo_repository.dart';

class GetAllTodos
    implements UseCase<Either<Failure, List<TodoTask>>, NoParams> {
  final TodoRepository repository;

  GetAllTodos(this.repository);

  @override
  Future<Either<Failure, List<TodoTask>>> call(NoParams params) {
    return repository.getAllTodos();
  }
}