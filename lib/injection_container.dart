import 'package:get_it/get_it.dart';

import 'package:clean_todo/features/todo/data/datasources/todo_db_helper.dart';
import 'package:clean_todo/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:clean_todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:clean_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:clean_todo/features/todo/domain/usecases/add_todo.dart';
import 'package:clean_todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:clean_todo/features/todo/domain/usecases/get_all_todos.dart';
import 'package:clean_todo/features/todo/domain/usecases/toggle_complete.dart';
import 'package:clean_todo/features/todo/domain/usecases/update_todo.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database helper
  sl.registerLazySingleton(() => TodoDbHelper());

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  // Usecases
  sl.registerLazySingleton(() => GetAllTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => ToggleComplete(sl()));

  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      getAllTodos: sl(),
      addTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
      toggleComplete: sl(),
    ),
  );
}
