import 'package:clean_todo/features/todo/presentation/pages/todo_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clean_todo/features/todo/domain/entities/todo_task.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_event.dart';
import 'package:clean_todo/features/todo/presentation/bloc/todo_state.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TodoFilter _filter = TodoFilter.all;
  String _searchQuery = "";
@override
void initState() {
  super.initState();
  context.read<TodoBloc>().add(LoadTodosEvent());
}

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final desc = descController.text.trim();

                if (title.isEmpty) return;

                final task = TodoTask(
                  title: title,
                  description: desc.isEmpty ? null : desc,
                  isCompleted: false,
                  createdAt: DateTime.now(),
                );

                context.read<TodoBloc>().add(AddTodoEvent(task));

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(TodoTask todo) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final desc = descController.text.trim();

                if (title.isEmpty) return;

                final updated = TodoTask(
                  id: todo.id,
                  title: title,
                  description: desc.isEmpty ? null : desc,
                  isCompleted: todo.isCompleted,
                  createdAt: todo.createdAt,
                );

                context.read<TodoBloc>().add(UpdateTodoEvent(updated));
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clean Todo")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search todo...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text("All"),
                  selected: _filter == TodoFilter.all,
                  onSelected: (_) {
                    setState(() => _filter = TodoFilter.all);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Pending"),
                  selected: _filter == TodoFilter.pending,
                  onSelected: (_) {
                    setState(() => _filter = TodoFilter.pending);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Completed"),
                  selected: _filter == TodoFilter.completed,
                  onSelected: (_) {
                    setState(() => _filter = TodoFilter.completed);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocConsumer<TodoBloc, TodoState>(
              listener: (context, state) {
                if (state is TodoError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TodoLoaded) {
                  final filtered = state.todos.where((todo) {
                    // Filter by status
                    final matchesFilter = switch (_filter) {
                      TodoFilter.all => true,
                      TodoFilter.pending => !todo.isCompleted,
                      TodoFilter.completed => todo.isCompleted,
                    };

                    // Filter by search
                    final matchesSearch = _searchQuery.isEmpty
                        ? true
                        : todo.title.toLowerCase().contains(_searchQuery);

                    return matchesFilter && matchesSearch;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No matching tasks"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final todo = filtered[index];

                      return ListTile(
                        onTap: () => _showEditTodoDialog(todo),
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) {
                            if (todo.id != null) {
                              context.read<TodoBloc>().add(
                                ToggleCompleteEvent(todo.id!),
                              );
                            }
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: todo.description == null
                            ? null
                            : Text(todo.description!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (todo.id != null) {
                              context.read<TodoBloc>().add(
                                DeleteTodoEvent(todo.id!),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
