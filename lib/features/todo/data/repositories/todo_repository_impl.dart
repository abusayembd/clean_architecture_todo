import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<TodoTask>>> getAllTodos() async {
    try {
      final result = await localDataSource.getAllTodos();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(DatabaseFailure("Unknown database error"));
    }
  }

  @override
  Future<Either<Failure, TodoTask>> addTodo(TodoTask task) async {
    try {
      final inserted = await localDataSource.addTodo(TodoModel.fromEntity(task));
      return Right(inserted);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(DatabaseFailure("Unknown database error"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int id) async {
    try {
      await localDataSource.deleteTodo(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(DatabaseFailure("Unknown database error"));
    }
  }

  @override
  Future<Either<Failure, TodoTask>> toggleComplete(int id) async {
    try {
      final updated = await localDataSource.toggleComplete(id);
      return Right(updated);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(DatabaseFailure("Unknown database error"));
    }
  }

  @override
  Future<Either<Failure, TodoTask>> updateTodo(TodoTask task) async {
    try {
      final updated =
          await localDataSource.updateTodo(TodoModel.fromEntity(task));
      return Right(updated);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (_) {
      return const Left(DatabaseFailure("Unknown database error"));
    }
  }
}