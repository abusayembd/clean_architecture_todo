import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clean_todo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clean_todo/features/todo/presentation/pages/todo_page.dart';
import 'package:clean_todo/injection_container.dart' as di;
import 'package:clean_todo/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<TodoBloc>(
        create: (_) => sl<TodoBloc>(),
        child: const TodoPage(),
      ),
    );
  }
}
