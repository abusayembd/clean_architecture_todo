import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/todo_task.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_all_todos.dart';
import '../../domain/usecases/toggle_complete.dart';
import '../../domain/usecases/update_todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetAllTodos getAllTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final ToggleComplete toggleComplete;

  TodoBloc({
    required this.getAllTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleComplete,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ToggleCompleteEvent>(_onToggleComplete);
  }

  // Helper: safely get current list
  List<TodoTask> _currentTodos(TodoState state) {
    if (state is TodoLoaded) return state.todos;
    return [];
  }

  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    final result = await getAllTodos(const NoParams());

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final oldTodos = _currentTodos(state);

    final result = await addTodo(event.task);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (insertedTodo) {
        // Update list locally (NO reload)
        final updated = [insertedTodo, ...oldTodos];
        emit(TodoLoaded(updated));
      },
    );
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final oldTodos = _currentTodos(state);

    final result = await updateTodo(event.task);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (updatedTodo) {
        final updated = oldTodos.map((t) {
          return (t.id == updatedTodo.id) ? updatedTodo : t;
        }).toList();

        emit(TodoLoaded(updated));
      },
    );
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final oldTodos = _currentTodos(state);

    final result = await deleteTodo(event.id);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) {
        final updated = oldTodos.where((t) => t.id != event.id).toList();
        emit(TodoLoaded(updated));
      },
    );
  }

  Future<void> _onToggleComplete(
    ToggleCompleteEvent event,
    Emitter<TodoState> emit,
  ) async {
    final oldTodos = _currentTodos(state);

    final result = await toggleComplete(event.id);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (updatedTodo) {
        final updated = oldTodos.map((t) {
          return (t.id == updatedTodo.id) ? updatedTodo : t;
        }).toList();

        emit(TodoLoaded(updated));
      },
    );
  }
}