import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/todo_repository.dart';

class DeleteTodo implements UseCase<Either<Failure, void>, int> {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.deleteTodo(params);
  }
}