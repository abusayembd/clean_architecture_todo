import 'package:bloc_test/bloc_test.dart';
import 'package:clean_todo/core/error/failures.dart';
import 'package:clean_todo/core/usecase/usecase.dart';
import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';
import 'package:clean_todo/features/todo/domain/usecases/add_todo.dart';
import 'package:clean_todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:clean_todo/features/todo/domain/usecases/get_all_todos.dart';
import 'package:clean_todo/features/todo/domain/usecases/toggle_complete.dart';
import 'package:clean_todo/features/todo/domain/usecases/update_todo.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllTodos extends Mock implements GetAllTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class MockToggleComplete extends Mock implements ToggleComplete {}

void main() {
  late TodoBloc bloc;
  late MockGetAllTodos mockGetAllTodos;
  late MockAddTodo mockAddTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;
  late MockToggleComplete mockToggleComplete;

  setUp(() {
    mockGetAllTodos = MockGetAllTodos();
    mockAddTodo = MockAddTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();
    mockToggleComplete = MockToggleComplete();

    bloc = TodoBloc(
      getAllTodos: mockGetAllTodos,
      addTodo: mockAddTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
      toggleComplete: mockToggleComplete,
    );
  });

  final todo = TodoTask(
    id: 1,
    title: "Test",
    description: "Hello",
    isCompleted: false,
    createdAt: DateTime(2025, 1, 1),
  );

  test("initial state should be TodoInitial", () {
    expect(bloc.state, TodoInitial());
  });

  blocTest<TodoBloc, TodoState>(
    "emits [TodoLoading, TodoLoaded] when LoadTodosEvent succeeds",
    build: () {
      when(
        () => mockGetAllTodos(const NoParams()),
      ).thenAnswer((_) async => Right([todo]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTodosEvent()),
    expect: () => [
      TodoLoading(),
      TodoLoaded([todo]),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    "emits [TodoLoading, TodoError] when LoadTodosEvent fails",
    build: () {
      when(
        () => mockGetAllTodos(const NoParams()),
      ).thenAnswer((_) async => const Left(DatabaseFailure("DB error")));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTodosEvent()),
    expect: () => [TodoLoading(), const TodoError("DB error")],
  );
}
