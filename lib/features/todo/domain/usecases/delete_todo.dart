import 'package:dartz/dartz.dart';

import 'package:clean_todo/core/error/failures.dart';
import 'package:clean_todo/core/usecase/usecase.dart';
import 'package:clean_todo/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodo implements UseCase<Either<Failure, void>, int> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.deleteTodo(params);
  }
}
