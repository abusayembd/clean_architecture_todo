import 'package:clean_todo/features/todo/data/datasources/todo_db_helper.dart';
import 'package:clean_todo/features/todo/data/models/todo_model.dart';

import 'package:clean_todo/core/error/exceptions.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getAllTodos();
  Future<TodoModel> addTodo(TodoModel model);
  Future<TodoModel> updateTodo(TodoModel model);
  Future<void> deleteTodo(int id);
  Future<TodoModel> toggleComplete(int id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final TodoDbHelper dbHelper;

  TodoLocalDataSourceImpl(this.dbHelper);
  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        TodoDbHelper.tableTodos,
        orderBy: '${TodoDbHelper.colCreatedAt} DESC',
      );
      return result.map((e) => TodoModel.fromMap(e)).toList();
    } catch (e) {
      throw DatabaseException("Failed to load todos");
    }
  }

  @override
  Future<TodoModel> addTodo(TodoModel model) async {
    try {
      final db = await dbHelper.database;

      final id = await db.insert(
        TodoDbHelper.tableTodos,
        model.toMap()..remove(TodoDbHelper.colId),
      );

      return TodoModel(
        id: id,
        title: model.title,
        description: model.description,
        isCompleted: model.isCompleted,
        createdAt: model.createdAt,
         priority: model.priority,
        dueDate: model.dueDate,
      );
    } catch (e) {
      throw DatabaseException("Failed to add todo");
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    try {
      final db = await dbHelper.database;

      await db.delete(
        TodoDbHelper.tableTodos,
        where: '${TodoDbHelper.colId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException("Failed to delete todo");
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel model) async {
    try {
      final db = await dbHelper.database;

      await db.update(
        TodoDbHelper.tableTodos,
        model.toMap()..remove('id'),
        where: '${TodoDbHelper.colId} = ?',
        whereArgs: [model.id],
      );

      return model;
    } catch (e) {
      throw DatabaseException("Failed to update todo");
    }
  }

  @override
  Future<TodoModel> toggleComplete(int id) async {
    final db = await dbHelper.database;

    final result = await db.query(
      TodoDbHelper.tableTodos,
      where: '${TodoDbHelper.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      throw DatabaseException("Todo not found");
    }

    final todo = TodoModel.fromMap(result.first);

    final updated = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
      createdAt: todo.createdAt,
      priority: todo.priority,
      dueDate: todo.dueDate,
    );

    await updateTodo(updated);

    return updated;
  }
}
